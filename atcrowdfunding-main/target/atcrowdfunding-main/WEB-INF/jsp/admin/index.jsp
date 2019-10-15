<%--
  Created by IntelliJ IDEA.
  User: 表裡不一的天邪鬼
  Date: 2019/10/6
  Time: 22:49
  To change this template use File | Settings | File Templates.
--%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

    <%@ include file="/WEB-INF/jsp/common/css.jsp" %>

    <style>
        .tree li {
            list-style-type: none;
            cursor:pointer;
        }
        table tbody tr:nth-child(odd){background:#F4F4F4;}
        table tbody td:nth-child(even){color:#C00;}
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <div class="panel panel-default">
                <div class="panel-heading">
                    <h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 数据列表</h3>
                </div>
                <div class="panel-body">
                    <form class="form-inline" role="form" style="float:left;">
                        <div class="form-group has-feedback">
                            <div class="input-group">
                                <div class="input-group-addon">查询条件</div>
                                <input id="condition" class="form-control has-success" type="text" value="${param.condition }" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button id="queryBtn" type="button" class="btn btn-warning"><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button id="deleteBatchBtn" type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right;" onclick="window.location.href='${PATH}/admin/toAdd'"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input id="thCheckbox" type="checkbox"></th>
                                <th>账号</th>
                                <th>名称</th>
                                <th>邮箱地址</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <c:forEach items="${page.list }" var="admin" varStatus="status">
                                <tr>
                                    <td>${status.count }</td>
                                    <td><input type="checkbox" adminId="${admin.id}" adminName="${admin.loginacct }"></td>
                                    <td>${admin.loginacct }</td>
                                    <td>${admin.username }</td>
                                    <td>${admin.email }</td>
                                    <td>
                                        <button type="button" onclick="window.location.href='${PATH}/admin/assign?id=${admin.id}'" class="btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
                                        <button type="button" onclick="window.location.href='${PATH}/admin/toUpdate?pageNum=${page.pageNum}&id=${admin.id}'" class="btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>
                                        <button id="deleteBtn" type="button" href="${PATH}/admin/doDelete?pageNum=${page.pageNum}&id=${admin.id}" class="btn btn-danger btn-xs"><i class=" glyphicon glyphicon-remove"></i></button>
                                    </td>
                                </tr>
                            </c:forEach>
                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <c:if test="${page.isFirstPage}">
                                            <li class="disabled"><a href="#">上一页</a></li>
                                        </c:if>
                                        <c:if test="${!page.isFirstPage}">
                                            <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${page.pageNum-1}">上一页</a></li>
                                        </c:if>

                                        <c:forEach items="${page.navigatepageNums }" var="num">
                                            <c:if test="${page.pageNum == num }">
                                                <li class="active"><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${num}">${num}</a></li>
                                            </c:if>
                                            <c:if test="${page.pageNum != num }">
                                                <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${num}">${num}</a></li>
                                            </c:if>
                                        </c:forEach>


                                        <c:if test="${page.isLastPage}">
                                            <li class="disabled"><a href="#">下一页</a></li>
                                        </c:if>
                                        <c:if test="${!page.isLastPage}">
                                            <li><a href="${PATH}/admin/index?condition=${param.condition}&pageNum=${page.pageNum+1}">下一页</a></li>
                                        </c:if>
                                    </ul>
                                </td>
                            </tr>

                            </tfoot>
                        </table>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<%@ include file="/WEB-INF/jsp/common/js.jsp" %>
<script type="text/javascript">
    $(function () {
        $(".list-group-item").click(function(){
            if ( $(this).find("ul") ) {
                $(this).toggleClass("tree-closed");
                if ( $(this).hasClass("tree-closed") ) {
                    $("ul", this).hide("fast");
                } else {
                    $("ul", this).show("fast");
                }
            }
        });
    });


    $("#queryBtn").click(function(){
        var condition = $("#condition").val();
        window.location.href="${PATH}/admin/index?condition="+condition;
    });

    //询问框
    $("#deleteBtn").click(function(){

        var href = $(this).attr("href");

        layer.confirm("确定要删除吗?",{btn:["确定","取消"]},function(index){


            window.location.href = href ;

            layer.close(index);
        },function(index){
            layer.close(index);
        });


    });






    $("#thCheckbox").click(function(){
        //$("tbody input[type='checkbox']").attr("checked",this.checked);
        $("tbody input[type='checkbox']").prop("checked",this.checked);
    });


    $("#deleteBatchBtn").click(function(){
        var selectCheckboxArray = $("tbody input[type='checkbox']:checked");

        if(selectCheckboxArray.length == 0){
            layer.msg("请选择要删除的用户!");
            return false ;
        }

        //  url?id=12&id=11&id=10
        //  url?id=12,11,10
        var ids = '';

        var idArray = new Array();
        $.each(selectCheckboxArray,function(i,e){
            var adminId = $(e).attr("adminId");
            idArray.push(adminId);
        });

        ids = idArray.join(",");

        layer.confirm("确定要删除吗?",{btn:["确定","取消"]},function(index){

            window.location.href = "${PATH}/admin/deleteBatch?pageNum=${page.pageNum}&ids="+ids ;

            layer.close(index);
        },function(index){
            layer.close(index);
        });
    });













</script>
</body>
</html>

