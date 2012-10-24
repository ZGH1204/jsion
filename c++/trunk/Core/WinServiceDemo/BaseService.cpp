#include "StdAfx.h"
#include "BaseService.h"

LPSTR					szServiceName;
SERVICE_STATUS_HANDLE   ssServiceStatusHandle;
VOID WINAPI ServiceMain(DWORD dwArgc, LPSTR* lpszArgv);
VOID WINAPI ServiceCtrlHandler(DWORD dwCtrlCode);
BOOL ReportStatusToSCMgr(SERVICE_STATUS_HANDLE hServiceStatus,DWORD dwCurrentState,DWORD dwErrorCode,DWORD dwWaitHint);

BaseService::BaseService(void)
{
}


BaseService::~BaseService(void)
{
}

BOOL BaseService::Create( LPTSTR szPath, LPSTR szServiceName )
{
	schSCManager = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);

	if(schSCManager)
	{
		schService = CreateService(
			schSCManager,					// SCM 句柄  
			szServiceName,					// 服务名  
			szServiceName,					// 显示的服务名  
			SERVICE_ALL_ACCESS,				// 存取权限
			SERVICE_WIN32_OWN_PROCESS,		// 服务类别  
			SERVICE_DEMAND_START,			// 启动类别
			SERVICE_ERROR_NORMAL,			// 错误控制类别
			szPath,							// 服务的可执行文件路径
			NULL,
			NULL,
			NULL,
			NULL,
			NULL);

		if (schService == NULL)
		{
			printf("CreateService failed (%d)\n", GetLastError());
			CloseServiceHandle(schSCManager);
			return FALSE;
		}
		else
		{
			printf("CreateService succeeded\n");   
			CloseServiceHandle(schService);
			CloseServiceHandle(schSCManager);
			return TRUE;  
		}
	}

	return FALSE;
}

BOOL BaseService::Delete( LPTSTR szServiceName )
{
	Stop(szServiceName);

	BOOL			bDeleted = FALSE;

	schSCManager = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS );

	if( schSCManager )
	{
		schService = OpenService( schSCManager, szServiceName, SERVICE_ALL_ACCESS );

		if ( schService )
		{
			bDeleted = DeleteService(schService);

			CloseServiceHandle(schService);
		}

		CloseServiceHandle(schSCManager);
	}

	return bDeleted;
}

BOOL BaseService::Start(LPSTR szServiceName)
{
	BOOL			bStarted = FALSE;

	DWORD			dwSleepLeft = 30000;

	DWORD			dwSleep = min( 1000, dwSleepLeft );

	schSCManager = OpenSCManager(NULL,NULL,SC_MANAGER_ALL_ACCESS);

	if(schSCManager)
	{
		schService = OpenService( schSCManager, szServiceName, SERVICE_ALL_ACCESS );

		if(schService)
		{
			if (StartService(schService, 0, NULL))
			{
				do 
				{
					Sleep(dwSleep);
					dwSleepLeft -= dwSleep;
					dwSleep = min( 1000, dwSleepLeft );

					QueryServiceStatus( schService, &ssServiceStatus );

					if (ssServiceStatus.dwCurrentState == SERVICE_RUNNING)
					{
						bStarted = TRUE;

						break;
					}
				} while (dwSleepLeft > 0);
			}

			CloseServiceHandle(schService);
		}

		CloseServiceHandle(schSCManager);
	}

	return bStarted;
}

BOOL BaseService::Stop( LPSTR szServiceName )
{
	BOOL			bStopped = FALSE;

	DWORD			dwSleepLeft = 30000;

	DWORD			dwSleep = min( 1000, dwSleepLeft );

	schSCManager = OpenSCManager( NULL, NULL, SC_MANAGER_ALL_ACCESS );

	if( schSCManager )
	{
		schService = OpenService( schSCManager, szServiceName, SERVICE_ALL_ACCESS );

		if ( schService )
		{
			if ( ControlService( schService, SERVICE_CONTROL_STOP, &ssServiceStatus ) )
			{
				do 
				{
					Sleep( dwSleep );
					dwSleepLeft -= dwSleep;
					dwSleep = min( 1000, dwSleepLeft );

					QueryServiceStatus( schService, &ssServiceStatus );

					if ( ssServiceStatus.dwCurrentState == SERVICE_STOPPED )
					{
						bStopped = TRUE;
						break;
					}
				} while (dwSleepLeft > 0);
			}

			CloseServiceHandle(schService);
		}

		CloseServiceHandle(schSCManager);
	}

	return bStopped;
}

BOOL ReportStatusToSCMgr( SERVICE_STATUS_HANDLE hServiceStatus,DWORD dwCurrentState,DWORD dwErrorCode,DWORD dwWaitHint )
{
	static DWORD dwCheckPoint = 0;    

	SERVICE_STATUS	ssStatus;

	memset( &ssStatus, 0, sizeof(ssStatus) );

	if ( dwCurrentState == SERVICE_RUNNING )  
		ssStatus.dwControlsAccepted = SERVICE_ACCEPT_STOP | SERVICE_ACCEPT_SHUTDOWN;
	else
		ssStatus.dwControlsAccepted = 0;

	ssStatus.dwServiceType = SERVICE_WIN32_OWN_PROCESS;
	ssStatus.dwCurrentState = dwCurrentState;

	if (dwErrorCode != 0)
		ssStatus.dwWin32ExitCode = ERROR_SERVICE_SPECIFIC_ERROR;
	else
		ssStatus.dwWin32ExitCode = NO_ERROR;
	ssStatus.dwServiceSpecificExitCode = dwErrorCode;
	ssStatus.dwWaitHint = dwWaitHint;

	if ( ( dwCurrentState == SERVICE_RUNNING ) ||
		( dwCurrentState == SERVICE_STOPPED ) ||
		( dwCurrentState == SERVICE_PAUSED ) )
		dwCheckPoint = 0;
	else
		dwCheckPoint++;

	ssStatus.dwCheckPoint = dwCheckPoint;

	if (!SetServiceStatus( hServiceStatus, &ssStatus)) 
	{
		return FALSE;
	}    
	else
		return TRUE;
}

BOOL BaseService::ExecServiceMain( LPSTR szServiceName )
{
	this->szServiceName = szServiceName;

	SERVICE_TABLE_ENTRY dispatchTable[] =
	{
		{ szServiceName, (LPSERVICE_MAIN_FUNCTION)ServiceMain },
		{ NULL, NULL }
	};

	if (!StartServiceCtrlDispatcher(dispatchTable))
	{
		return FALSE;
	}

	return TRUE;
}

VOID WINAPI ServiceMain( DWORD dwArgc, LPSTR* lpszArgv )
{
	ssServiceStatusHandle = RegisterServiceCtrlHandler(szServiceName, ServiceCtrlHandler);

	if (!ssServiceStatusHandle)
	{
		printf("无法注册服务程序的控制函数");
	}

	//TODO: 通知服务管理器并执行服务函数
}

void WINAPI ServiceCtrlHandler( DWORD dwCtrlCode )
{
	switch(dwCtrlCode)
	{
	case SERVICE_CONTROL_STOP:
	case SERVICE_CONTROL_SHUTDOWN:
		{
			ReportStatusToSCMgr(ssServiceStatusHandle, SERVICE_STOP_PENDING, 0, 5000);
		}
		return;

	case SERVICE_CONTROL_INTERROGATE:
		break;
	}

	ReportStatusToSCMgr(ssServiceStatusHandle, dwCtrlCode, 0, 5000);
}
