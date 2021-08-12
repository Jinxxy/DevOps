# 安装dotnet环境
> 官方文档 https://docs.microsoft.com/zh-cn/dotnet/core/install/linux-centos

## 安装dotnet core2.1
> 如果已安装 SDK 或运行时，请使用 `dotnet --list-sdks` 和 `dotnet --list-runtimes` 命令查看安装了哪些版本。

### 注册microsoft秘钥和源

sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

### 安装.NET Core SDK 2.1

sudo yum install dotnet-sdk-2.1

### 安装ASP.NET Core 2.1 运行时

sudo yum install aspnetcore-runtime-2.1

### 测试.NET SDK安装是否成功

dotnet --version

## 安装dotnet core 3.1

### 注册microsoft秘钥和源

sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

### 安装.NET Core SDK 3.1

sudo yum install dotnet-sdk-3.1

### 安装ASP.NET Core3.1运行时

sudo yum install aspnetcore-runtime-3.1

### 测试.NET SDK安装是否成功

dotnet --version

## 安装dotnet core 5.0

> 安装 .NET 之前，请运行以下命令，将 Microsoft 包签名密钥添加到受信任密钥列表，并添加 Microsoft 包存储库。 打开终端并运行以下命令：

sudo rpm -Uvh https://packages.microsoft.com/config/centos/7/packages-microsoft-prod.rpm

### 安装 SDK

sudo yum install dotnet-sdk-5.0

### 安装运行时

> 通过 ASP.NET Core 运行时，可以运行使用 .NET 开发且未提供运行时的应用。 以下命令将安装 ASP.NET Core 运行时，这是与 .NET 最兼容的运行时。 在终端中，运行以下命令：

sudo yum install aspnetcore-runtime-5.0

> 作为 ASP.NET Core 运行时的一种替代方法，你可以安装不包含 ASP.NET Core 支持的 .NET 运行时：将上一命令中的 `aspnetcore-runtime-5.0` 替换为 `dotnet-runtime-5.0`：

sudo yum install dotnet-runtime-5.0

## 部署
.NET Core项目部署到Linux https://www.cnblogs.com/jayjiang/p/12610545.html
CentOS7上部署.Net Core项目 https://www.pianshen.com/article/321959506/
在CentOS7中部署ASP.NET Core Web应用 http://blog.bossma.cn/dotnet/centos7-deploy-asp-net-core-web-app/
