#pragma once
class BaseService
{
public:
	BaseService(void);
	~BaseService(void);

public:
	//************************************
	// Method:    Create
	// FullName:  BaseService::Create
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: 创建服务 
	// Parameter: SC_HANDLE schSCManager SCM句柄 
	// Parameter: LPTSTR szPath 服务程序的路径 
	// Parameter: LPSTR szServiceName 服务名 
	//************************************
	BOOL Create(LPTSTR szPath, LPSTR szServiceName);
	//************************************
	// Method:    Delete
	// FullName:  BaseService::Delete
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: 删除服务
	// Parameter: LPTSTR szNameOfService 服务名
	//************************************
	BOOL Delete(LPTSTR szServiceName);

	//************************************
	// Method:    Start
	// FullName:  BaseService::Start
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: 启动服务
	// Parameter: LPSTR szServiceName 服务名
	//************************************
	BOOL Start(LPSTR szServiceName);

	//************************************
	// Method:    Stop
	// FullName:  BaseService::Stop
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: 停止服务
	// Parameter: LPSTR szServiceName 服务名
	//************************************
	BOOL Stop(LPSTR szServiceName);

	//************************************
	// Method:    ExecServiceMain
	// FullName:  BaseService::ExecServiceMain
	// Access:    public 
	// Returns:   BOOL
	// Qualifier: 执行服务主函数
	// Parameter: LPSTR szServiceName
	//************************************
	BOOL ExecServiceMain(LPSTR szServiceName);

public:
	SC_HANDLE				schService;
	SC_HANDLE				schSCManager;
	SERVICE_STATUS          ssServiceStatus;
};

