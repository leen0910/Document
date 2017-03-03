# robot转发服务http接口 1.0

[![Build Status](https://travis-ci.org/isagalaev/highlight.js.svg?branch=master)](https://travis-ci.org/isagalaev/highlight.js)

### 更新时间：2017年1月11日09:41:24

## 目录
* [接口说明](#1.1)

* [1. 设备信息](#1.1)
  - [1.1 读取设备运行信息](#1.1)
* [附录：设备错误码对照表](#10.1)
---

### 接口说明 

* 1.接口数据全部采用JSON格式
* 2.JSON字段都采用小写字母,数字命名，单词间采用“_”连接,JSON字符串值中的单位采用标准大小写形式。
* 3.默认JSON字段都必须填写，*号开头的字段为选填字段。


---

## <p id="1.1"/>1.1 读取设备运行信息  `URL：/api/infos/search` 
### 方法：GET
### 功能：根据条件分页查询设备信息。
### 客户端请求 示例：
```js
http://192.168.1.123:8081/api/infos/search?page[offset]=1&page[limit]=5
```
* page[offset]: `int` 查询的偏移量
* page[limit]: `int` 每页返回的数量

### 服务器正确返回 示例：
```js
{
  "total": 14,
  "data": [
    {
      "id": "586b1be919d2091bd89b4767",
      "name": "test_dev1",
      "serial": "67d09df8-e15b-43ea-ba18-ce6782f4e4c1",
      "model": "",
      "boot_time": "2016-02-15 06:02:01",
      "run_time": 150,
      "run_count": 50,
      "status": 0,
      "program": "test123451",
      "ip": "192.168.1.123",
      "data": "{\"algorithm_version\":\"v1.4\",\"boot_time\":\"2016-02-15 06:02:01\",\"controller_version\":\"v3.0.1.2\",\"driver_version\":{\"r\":\"v1.1\",\"x\":\"v1.1\",\"y\":\"v1.1\",\"z\":\"v1.1\"},\"io_version\":{\"gio\":\"v1.1\",\"mio\":\"v1.1\"},\"model\":\"axis4\",\"name\":\"test_dev1\",\"program\":\"test123451\",\"run_count\":50,\"run_time\":150,\"serial\":\"67d09df8-e15b-43ea-ba18-ce6782f4e4c1\",\"status\":0}",
      "online": true,
      "is_send": false,
      "created_time": "2017-01-03 11:35:05"
    },
    {
      "id": "586b2fe45a2a1327f082764d",
      "name": "test_dev122",
      "serial": "67d09df8-e15b-43ea-ba18-ce6782f4e4c9",
      "model": "",
      "boot_time": "2016-02-15 01:02:01",
      "run_time": 50000,
      "run_count": 50,
      "status": 0,
      "program": "test123456",
      "ip": "192.168.1.122",
      "data": "{\"algorithm_version\":\"v1.4\",\"boot_time\":\"2016-02-15 01:02:01\",\"controller_version\":\"v3.0.1.2\",\"driver_version\":{\"r\":\"v1.1\",\"x\":\"v1.1\",\"y\":\"v1.1\",\"z\":\"v1.1\"},\"io_version\":{\"gio\":\"v1.1\",\"mio\":\"v1.1\"},\"model\":\"axis4\",\"name\":\"test_dev\",\"program\":\"test123456\",\"run_count\":50,\"run_time\":1e+11,\"serial\":\"67d09df8-e15b-43ea-ba18-ce6782f4e4c9\",\"status\":0}",
      "online": false,
      "is_send": false,
      "created_time": "2017-01-03 11:22:49"
    }
  ]
}
```
* id: `string` 数据在数据库中的ID
* name: `string` 设备名称
* serial: `string` 设备序列号
* model: `string` 设备型号
* boot_time: `string` 开机时间
* run_time: `uint` 设备开机后运行的秒数
* run_count: `uint` 程序的运行次数
* status: `int` 设备状态（0:未初始化,1：初始化完成 2：执行程序 3：故障）
* version: `string` 主控版本号
* program: `string` 设备正在运行的程序名称（没有运行时为空）
* ip: `string` 设备ip
* data: `string` 需要发送到云端服务器的数据
* online: `bool` 设备是否在线
* is_send: `bool` 是否已经发送到云端服务器
* created_time: `string` 数据创建的时间

-------------------------------------------------------------------------------

## <p id="10.1"/>10.1 附录错误信息对照表




 