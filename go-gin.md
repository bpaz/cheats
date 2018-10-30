---
title: Gin Web Framework
category: golang
layout: 2017/sheet
updated: 2018-10-30
description: "Gin is a web framework written in Go (Golang). It features a martini-like API with much better performance, up to 40 times faster thanks to httprouter. If you need performance and good productivity, you will love Gin."
---

### Quick start

```go
package main

import "github.com/gin-gonic/gin"

func main() {
	r := gin.Default()
	r.GET("/ping", func(c *gin.Context) {
		c.JSON(200, gin.H{
			"message": "pong",
		})
	})
	r.Run() // listen and serve on 0.0.0.0:8080
}
 ```

## Method reference

| Get param in path | `c.Param("name")` |
| Get query param | `c.Query("lastname")` |




## References
{: .-one-column}

* <https://github.com/gin-gonic/gin>