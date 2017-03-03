
Cloud Server HTTP Interface v2.0 Revised
==================================
![Build Status](https://travis-ci.org/isagalaev/highlight.js.svg?branch=master)

`NOTE`  基于API2GO框架的数据模型接口

`NOTE`  2017-01-05 created by zhezhang

`NOTE`  2017-01-13 revised by zhezhang 

----------


# Overview 

> 1. 此协议为杭州琦星机器人有限公司云服务器开发约定接口协议。
> 2. 仅限内部使用。

----------

# Content

* [1. Description](#1)
  - [1. 1 URL Naming Rules ](#1.1)
  - [1. 2 Interface Return Data](#1.2)
  - [1. 3 Status Code](#1.3)
  - [1. 4 Time & Date Format](#1.4)
* [2. User](#2)
  - [2. 1 Overview](#2.1)
  - [2. 2 Model](#2.2)
  - [2. 3 Interface](#2.3)
* [3. Program](#3)
  - [3. 1 Overview](#3.1)
  - [3. 2 Model](#3.2)
  - [3. 3 Interface](#3.3)
* [4. Parameter](#4)
  - [4. 1 Overview](#4.1)
  - [4. 2 Model](#4.2)
  - [4. 3 Interface](#4.3)
* [5. Device](#5)
  - [5. 1 Overview](#5.1)
  - [5. 2 Model](#5.2)
  - [5. 3 Interface](#5.3)
* [6. App Update](#6)
  - [6. 1 Overview](#6.1)
  - [6. 2 Model](#6.2)
  - [6. 3 Interface](#6.3)
* [7. Robot](#5)
  - [7. 1 Overview](#7.1)
  - [7. 2 Robot Property Model](#7.2)
     + [7.2.1 Model](#7.2.1)
     + [7.2.2 Interface](#7.2.2)
	     * [a. Create Robot Property](#a)
	     * [b. Query One Robot Property](#b)
	     * [c. Query All Robot Property](#c)
	     * [d. Modify One Robot Property](#d)
	     * [e. Delete One Robot Property](#e)
  - [7. 3 Robot Data Model](#7.3)
        + [7.3.1 Model](#7.2.1)
	    + [7.3.2 Interface](#7.2.2)
		    * [a. Create Robot Data](#a)
	        * [b. Query One Robot Data](#b)
	        * [c. Query All Robot Data](#c)
	        * [d. Delete One Robot Data](#d)
  - [7. 4 Robot Log Model](#7.3)
        + [7.4.1 Model](#7.2.1)
	    + [7.4.2 Interface](#7.2.2)
	        * [a. Create Robot Log](#a)
	        * [b. Query One Robot Log](#b)



----------

# <p id="1"/>1. Description 

## <p id="1.1"/>1. 1 URL Naming Rules 
    
>    1. `URL` 请求采用小写字母，部分特殊符号（非制表符）组成。 
>    2. `URL` 请求中采用全小写单词，如果需要连接多个单词，则采用连接符`-`连接单词。

## Interface Rules 
 
>    1. 采用 `GET`方法获取数据
>    2. 采用 `POST` 方法增加和发送数据, 文件上传 
>    3. 采用 `PATCH`方法修改数据
>    4. 采用`DELETE`方法删除数据
>    5. 接口数据都采用`json`格式，`json`字段都采用小写命名
>    6. `Post` 方法` json` 字段都必须填写，`?`号开头的字段为选填字段。

## <p id="1.2"/>1. 2 Interface Return Data [ *Not Determined* ]

``` 
    接口正确： 
	    有数据： Json数据包
		无数据： { "status": 200 (int) }
	接口错误：
	    {
	       "status": 错误码 (int)
	       "description": "错误描述" (string)
	    }
```

## <p id="1.3"/>1. 3 Status Code [ *Not Determined* ]
```
<!-- 后台返回给前端开发人员的请求状态信息 -->
<!-- 4xx 客户端错误 --> 
	4000: Id Format Wrong     | Id格式不符合数据库设计要求
	4001: Json Format Wrong   | Json包解析错误，可能字段类型不匹配
	4002: Parameters Invalid  | 参数值为空或参数格式错误
	4003: Data Already Exists | 数据已经存在
	4004: Data Not Found      | 数据没有找到
	4005: Login Failed        | 登陆失败
	4006: Cookie_Invalid      | Json Web Token无效
<!-- 5xx 服务端错误 -->
	5000: Server Exception    | 服务器异常或数据库读写失败
```

## <p id="1.4"/>1. 4 Time & Date Format
```
<!-- 程序中使用的日期全按以下格式处理 -->  
	日期格式：yyyy-mm-dd (2006-01-02)
	时间格式：yyyy-mm-dd hh-mm-mm (2006-01-02 15:04:05)
```  

----------

# <p id="2"/>2. User 

## <p id="2.1"/>2.1 Overview

> 云服务用户信息，抽象为`User`数据模型，即`type User struct{}`结构体对象。该模型可能涉及多个子模型，在设计时作为内嵌对象进行映射，不作为独立模型处理。对于用户登陆和注销则抽象为独立接口`Login` & `Logout` 。

> 用户可选择`Windows`、`Phone(android、ios)`、`Pad`三种类型设备进行登陆，允许同一账号在这三种终端平台同时在线，但不允许同一账号在某一类型下(如`Phone`)的多台设备(`android_a` | `android_b` | `ios_a`)上同时登陆。当发生以上情况时，需服务器主动推送下线消息给另一设备，并完成强制下线。

> 用户可从账号，手机号，邮箱中选取一个注册成为`HZQX Cloud`用户，目前仅支持账号这一类型。后续可以考虑将用户`登陆设备`对象抽取出来和用户信息构成`DBRef`引用关系。

## <p id="2.2"/>2.2 Model

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            		示例值
account				string		Y		账号(唯一)(6-20位字符)
nickname			string		?		昵称(6-20位字符)
password			string		Y		密码(6-20位字符，包括数字,字母,下划线)
phone				string		?		手机，可为账号
email				string		?		邮箱，可为账号
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            		示例值
u_id			    string				用户id(bson.ObjectId)
is_deleted 			bool				用户是否被删除
deleted_time 		string				用户被删除时间
created_time	    string			    用户注册时间
modified_time	    string			    用户信息修改时间

windows				Object				windows登陆
	login_time	    string 				登陆时间
	logout_time	    string				注销时间
	is_logined		bool				是否登陆成功
	
phone				Object				phone登陆
	login_time	    string 				登陆时间
	logout_time	    string				注销时间
	is_logined		bool				是否登陆成功
	platform		string				phone平台		    "android" | "ios"

pad					Object				pad登陆
	login_time	    string 				登陆时间
	logout_time	    string				注销时间
	is_logined		bool				是否登陆成功
```
## <p id="2.3"/>2.3 Interface

### <p id="2.3.1"/>2.3.1 Register
```
请求地址：	/v1.0/users
请求方法：	POST
接口功能：	用户注册
请求参数：	<body> account,phone,email,password,nickname
响应参数：
请求实例：
响应实例：
接口备注：
```
### <p id="2.3.2"/>2.3.2 Login
```
请求地址：	/v1.0/users/login
请求方法：	POST
接口功能：	登陆
请求参数：	<body> account,phone,email,password,platform
响应参数：
请求实例：
响应实例：
接口备注：	创建token时，需包含u_id; u_id可在后续接口需要时从token提取。
```
### <p id="2.3.3"/>2.3.3 Logout
```
请求地址：	/v1.0/users/logout
请求方法：	POST
接口功能：	注销
请求参数：
响应参数：
请求实例：
响应实例：
接口备注：
```

----------

# <p id="3"/>3 Program 

## <p id="3.1"/>3.1 Overview

> 用户程序文件，抽象为 `Program` 数据模型，即`type Program struct{}` 结构体对象；在接口请求中，通过token提取`u_id` 引用到`User DBRef`，与User集合建立引用关系，用于获取用户数据随Program接口一并返回。

## <p id="3.2"/>3.2 Model

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            		示例值
p_id				string		Y		程序文件id
program				string		？		程序文件数据
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            		示例值
id				    string				文档id(bson.ObjectId)
is_deleted 			bool				文档是否被删除
deleted_time 		string				文档删除时间
created_time	    string			    文档创建时间
modified_time	    string			    文档修改时间
user_dbref			dbref				用户集合引用
					collection			集合
					id					u_id
					db					数据库
```
## <p id="3.3"/>3.3 Interface

### <p id="3.3.1"/>3.3.1 Upload
```
请求地址：	/v1.0/programs
请求方法：	POST
接口功能：	上传某个程序文件到云端备份，保存在当前账号下。
请求参数：	<header> token
			<body>   p_id, program
响应参数：	
请求实例：
响应实例：
接口备注：	
```
### <p id="3.3.2"/>3.3.2 Get Lists of Program
```
请求地址：	/v1.0/programs/*name
请求方法：	GET
接口功能：	获取当前账号下，云端程序文件的列表
请求参数：	<url>    name=list page=?
			<header> token
响应参数：	program lists, 具体字段见响应实例
请求实例：
响应实例：
接口备注：	支持分页获取
```
### <p id="3.3.3"/>3.3.3 Download
```
请求地址：	/v1.0/programs/:name
请求方法：	GET
接口功能：	下载当前账号下的某一程序文件
请求参数：	<url>    name=p_id
			<header> token
响应参数：	program data, 具体字段见响应实例
请求实例：
响应实例：
接口备注：
```
----------

#<p id="4"/>4. Parameter 

## <p id="4.1"/>4.1 Overview

> 应用程序参数，抽象为 `Parameter` 数据模型，即`type Parameter struct{}` 对象；不同类型参数将其分类，然后抽取为子模型(取值到叶子结点)，内嵌到Parameter结构体，对应MongoDB内嵌文档。

## <p id="4.2"/>4.2 Model

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            		示例值
basic_para   		object				基础参数
	data			string				数据
	created_time	string				创建时间
	modified_time	string			    修改时间
ordinary_para		object				安全+一般限制参数
	data			string				数据
	created_time	string				创建时间
	modified_time	string				修改时间
joint_para			object				安全+关节限制参数
	data			string				数据
	created_time	string				创建时间
	modified_time	string				修改时间
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            		示例值
id				    string				文档id
is_deleted 			bool				文档是否被删除
deleted_time 		string				文档删除时间
created_time	    string			    文档创建时间
modified_time	    string			    文档修改时间
user_dbref			dbref				用户集合引用
					collection			集合
					id					文档id
					db					数据库
```
## <p id="4.3"/>4.3 Interface

### <p id="4.3.1"/>4.3.1 Upload
```
请求地址：	/v1.0/parameters/:name
请求方法：	POST
接口功能：	上传程序参数到云端备份，保存在当前账号下。
请求参数：	<url>    name=para_type
		    <header> token
			<body>   data
响应参数：	
请求实例：
响应实例：
接口备注：
```
### <p id="4.3.2"/>4.3.2 Download
```
请求地址：	/v1.0/parameters/:name
请求方法：	GET
接口功能：	下载云端账号下的程序参数到本地软件
请求参数：	<url>    name=para_type
			<header> token
响应参数：	program data, 具体字段见响应实例
请求实例：
响应实例：
接口备注：
```
----------

# <p id="5"/>5. Device 

## <p id="5.1"/>5.1 Overview 

> 设备出厂数据和购买者信息，抽象为`Device`数据模型，即`type Device struct{}`结构体对象。一个设备序列号对应MongoDB的一个文档。

> 1. 出厂设备，购买设备的公司，Cloud账号之间的关系，即数据模型有联系？
> 3. 设备在出厂时应该记录那些字段数据？

## <p id="5.2"/>5.2 Model

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            		示例值
serial				string		Y		设备序列号
buy_time			string		Y		购买设备时间
actived_time		string 		Y 		激活设备时间
expiration			string  	Y 		设备到期时间
is_activated		bool		Y		设备是否被激活
c_id				string		Y		公司代号id
company				string		Y		公司名称
company_addr		string		Y		公司地址
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            		示例值
id				    string				文档id
is_deleted 			bool				文档是否被删除
deleted_time 		string				文档删除时间
created_time	    string			    文档创建时间
modified_time	    string			    文档修改时间
```
## <p id="5.3"/>5.3 Interface

### <p id="5.3.1"/>5.3.1 Activate devices
```
请求地址：	/v1.0/devices
请求方法：	POST
接口功能：	激活设备
请求参数：	<header> token
			<body>   company, serial[](array)
响应参数：	
请求实例：
响应实例：
接口备注：
```
----------

#<p id="6"/>6. App Update

## <p id="6.1"/>6.1 Overview 

> 软件版本升级，抽象出两个数据模型：`Version` & `New Version`; 其中，Version用来存放所有软件的版本信息和更新记录；New Version 用来存放最新软件版本信息。在此，我们对外只暴露Version这个数据模型， `New Verison`独立为一个接口，用于查询最新的软件版本信息。

> 软件版本分为：Windows、Android、Pad、Ios

## <p id="6.2"/>6.2 Model

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            		示例值
version				string		Y		App版本号
platform 			string		Y		App更新平台
size				uint32		Y		App大小
level				uint		Y 		App更新级别(0-可选，1-强制)
description			string		Y		App更新描述
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            		示例值
id				    string				文档id
is_deleted 			bool				文档是否被删除
deleted_time 		string				文档删除时间
created_time	    string			    文档创建时间
modified_time	    string			    文档修改时间
```
## <p id="6.3"/>6.3 Interface

### <p id="6.3.1"/>6.3.1 Get New Version
```
请求地址：	/v1.0/newversions/:name
请求方法：	GET
接口功能：	获取软件最新版本信息
请求参数：	<url>    name=platform
			<header> token
响应参数：	
请求实例：
响应实例：
接口备注：
```
### <p id="6.3.2"/>6.3.2 Download Update Package
```
请求地址：	/v1.0/download/qx-studio/platform/filename

			Windows:/v1.0/download/qx-studio/windows/v1.0.0.zip (zip文件)
			Android:/v1.0/download/qx-studio/android/v1.0.0.apk (apk文件)
			Pad:	/v1.0/download/qx-studio/pad/v1.0.0.apk     (apk文件)
			Ios:	/v1.0/download/qx-studio/ios/v1.0.0.ipa     (ipa文件)
			
请求方法：	静态文件服务
接口功能：	下载最新版软件
请求参数：
响应参数：	
请求实例：
响应实例：
接口备注：
```
----------

# <p id="7"/>7. Robot 

## <p id="7.1"/>7.1 Overview

> Robot参数和数据，抽象为`Robot属性`和`Robot日志`两个模型，而`Robot属性`再次抽象为`Property`和`Data`两个子数据模型：`Property` 只在Robot启动后发送一次，然后当有属性改变时再次推送最新数据到服务器，`Data` 在Robot启动后需按规定的频率推送数据到服务器。在此，以`子模型` 为基础进行接口设计与实现。`Log` 模型数据也是按一定频率推送到服务器。

>原则上，每个模型都有Create、FindOne、FindAll、Delete、Patch5个接口，在此我们按实际需求实现。 
	
## <p id="7.2"/>7.2 Robot Property Model

### <p id="7.2.1"/>7.2.1 Model (MongoDB Collection)

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            示例值
name			    string 			    设备名称
model			    string			    设备型号
serial			    string			    设备序列号
boot_time		    string			    设备开机时间
ctrl_version	    string			    控制器版本号
alg_version		    string			    算法库版本号
driver_version	    Object			    驱动器版本号
       joint_1	    string			       关节1
       joint_2		string 			       关节2
       joint_3		string			       关节3
       joint_4		string 			       关节4
io_version		    Object			    io版本号
	   main		    string			       主io
	   tool		    string 			       工具io
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            示例值
id				    string				文档id
is_deleted 			bool				文档是否被删除
deleted_time 		string				文档删除时间
created_time	    string			    文档创建时间
modified_time	    string			    文档修改时间
```

### <p id="7.2.2"/>7.2.2 Interface

##### <p id="a"/>a. Create Robot Data 
```
请求地址：	/v1.0/properties
请求方法：	POST
接口功能：	生成机器人固有属性数据
请求参数：	<header> token
			<body>   model(如模型所示)
响应参数：	
请求实例：
响应实例：
接口备注： 
```
##### <p id="b"/>b. Query One Robot Data 
```
请求地址：	/v1.0/properties/:name
请求方法：	GET
接口功能：	查找某个机器人固有属性数据
请求参数：	<url>    name=serial
			<header> token
响应参数：	
请求实例：
响应实例：
接口备注：
```
##### <p id="c"/>c. Query All Robot Data 
```
请求地址：	/v1.0/parameters/:name
请求方法：	GET
接口功能：	查找所有机器人固有属性数据
请求参数：	<url>    name=all, page=?
			<header> token
响应参数：
请求实例：
响应实例：
接口备注：	支持分页获取
```
#####<p id="d"/>d. Modify One Robot Data 
```
请求地址：	/v1.0/parameters
请求方法：	PATCH
接口功能：	更新机器人固有属性数据
请求参数：	<header> token
			<body>   serial, modify data
响应参数：	
请求实例：
响应实例：
接口备注： 
```
##### <p id="e"/>e. Delete One Robot Data 
```
请求地址：	/v1.0/parameters
请求方法：	DELETE
接口功能：	删除机器人固有属性模型
请求参数：	<url>    serial
			<header> token
响应参数：	
请求实例：
响应实例：
接口备注： 
```

## <p id="7.3"/>7.3 Robot Data Model

###<p id="7.3.1"/>7.3.1 Model (MongoDB Collection)

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            示例值
status				uint				设备运行状态
run_time			uint				程序运行时间
run_count 			uint 				程序运行次数
boot_time  			float32				设备开机时长	
program_name 		string				设备当前运行程序
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            示例值
id				    string				文档id
is_deleted 			bool				文档是否被删除
deleted_time 		string				文档删除时间
created_time	    string			    文档创建时间
modified_time	    string			    文档修改时间
```

### <p id="7.3.2"/>7.3.2 Interface

##### <p id="a"/>a. Create Robot Data 
```
请求地址：	/v1.0/datas
请求方法：	POST
接口功能：	生成机器人状态数据
请求参数：	<header> token
			<body>   model(如模型所示)
响应参数：
请求实例：
响应实例：
接口备注： 
```
##### <p id="b"/>b. Query One Robot Data 
```
请求地址：	/v1.0/datas/:name
请求方法：	GET
接口功能：	查询某个机器人状态数据
请求参数：	<url>    name=serial
			<header> token
响应参数：
请求实例：
响应实例：
接口备注： 
```
##### <p id="c"/>c. Query All Robot Data 
```
请求地址：	/v1.0/datas/:name
请求方法：	GET
接口功能：	查询所有机器人状态数据
请求参数：	<url>    name=all
			<header> token
响应参数：
请求实例：
响应实例：
接口备注： 	支持分页获取
```
##### <p id="d"/>d. Delete One Robot Data 
```
请求地址：	/v1.0/datas
请求方法：	DELETE
接口功能：	删除机器人状态数据
请求参数：	<url>    serial
			<header> token
响应参数：
请求实例：
响应实例：
接口备注： 
```

## <p id="7.4"/>7.4 Robot Log Model

### <p id="7.4.1"/>7.4.1 Model (MongoDB Collection)

`公共参数`
``` 
字段名称             数据类型    是否必填    说明            示例值
name                string              设备名称
serial              string              设备序列号
model               string              设备型号
status              uint                错误码     
description         string              日志信息
log_level           uint                日志等级（1-4: info,warn,error,critical）
```
`私有参数(后台维护)`
```	
字段名称             数据类型    是否必填    说明            示例值
id				    string				文档id
is_deleted 			bool				文档是否被删除
deleted_time 		string				文档删除时间
created_time	    string			    文档创建时间
modified_time	    string			    文档修改时间
```

### <p id="7.4.2"/>7.4.2 Interface

##### <p id="a"/>a. Create Robot Log
```
请求地址：	/v1.0/logs
请求方法：	POST
接口功能：	生成机器人日志数据
请求参数：	<header> token
			<body>   model(如模型所示)
响应参数：
请求实例：
响应实例：
接口备注： 
```
##### <p id="b"/>b. Query One Robot Log
```
请求地址：	/v1.0/logs
请求方法：	GET
接口功能：	生成机器人日志数据
请求参数：	<url>    name=serial
			<header> token
响应参数：
请求实例：
响应实例：
接口备注： 
```


#<p id="8"/>8. Question

* 接口响应参数现在还未确定。