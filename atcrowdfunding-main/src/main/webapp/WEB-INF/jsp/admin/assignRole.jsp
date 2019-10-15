<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>

<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="GB18030">
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
    </style>
</head>

<body>

<jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

<div class="container-fluid">
    <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
            <ol class="breadcrumb">
                <li><a href="#">首页</a></li>
                <li><a href="#">数据列表</a></li>
                <li class="active">分配角色</li>
            </ol>
            <div class="panel panel-default">
                <div class="panel-body">
                    <form role="form" class="form-inline">
                        <div class="form-group">
                            <label for="exampleInputPassword1">未分配角色列表</label><br>
                            <select id="leftRoleList" class="form-control" multiple size="10" style="width:250px;overflow-y:auto;">
                                <c:forEach items="${unAssignList}" var="role">
                                    <option value="${role.id }">${role.name }</option>
                                </c:forEach>
                            </select>
                        </div>
                        <div class="form-group">
                            <ul>
                                <li id="leftToRightBtn" class="btn btn-default glyphicon glyphicon-chevron-right"></li>
                                <br>
                                <li id="rightToLeftBtn" class="btn btn-default glyphicon glyphicon-chevron-left" style="margin-top:20px;"></li>
                            </ul>
                        </div>
                        <div class="form-group" style="margin-left:40px;">
                            <label for="exampleInputPassword1">已分配角色列表</label><br>
                            <select id="rightRoleList" class="form-control" multiple size="10" style="width:250px;overflow-y:auto;">
                                <c:forEach items="${assignList}" var="role">
                                    <option value="${role.id }">${role.name }</option>
                                </c:forEach>
                            </select>
                        </div>
                    </form>
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



    //分配角色
    $("#leftToRightBtn").click(function(){
        var selectedOption = $("#leftRoleList option:selected");

        if(selectedOption.length==0){
            layer.msg("请先选择角色,再进行分配.",{time:1000,icon:5});
            return false ;
        }


        var adminId = "${param.id}";

        var json = {
            adminId:adminId
        };

        $.each(selectedOption,function(i,e){
            var roleId = e.value;
            json['ids['+i+']'] = roleId ;

            //json['adminList[1].name'] = name;
            //json['adminList[1].email'] = email;
        });


        console.log(json);

        $.post("${PATH}/admin/doAssign",json,function(result){
            if(result=="ok"){
                layer.msg("分配成功.",{time:1000,icon:6},function(){
                    $("#rightRoleList").append(selectedOption.clone());
                    selectedOption.remove();
                });
            }else{
                layer.msg("分配失败.",{time:1000,icon:5});
            }
        });

        /*  实验1：
        var params = '';
        $.each(selectedOption,function(i,e){
            var roleId = e.value;
            if(i!=0){
                params += '&' ;
            }
            params += 'ids='+roleId ;

        });

        params+="&adminId="+adminId ;

        console.log(params);


        $.post("${PATH}/admin/doAssign",params,function(result){
            		alert(result);
            	});
            	 */







    });


    //取消分配角色
    $("#rightToLeftBtn").click(function(){
        var selectedOption = $("#rightRoleList option:selected");

        if(selectedOption.length==0){
            layer.msg("请先选择角色,再取消分配.",{time:1000,icon:5});
            return false ;
        }


        var adminId = "${param.id}";

        var json = {
            adminId:adminId
        };

        $.each(selectedOption,function(i,e){
            var roleId = e.value;
            json['ids['+i+']'] = roleId ;
        });


        console.log(json);

        $.post("${PATH}/admin/doUnAssign",json,function(result){
            if(result=="ok"){
                layer.msg("取消分配成功.",{time:1000,icon:6},function(){
                    $("#leftRoleList").append(selectedOption.clone());
                    selectedOption.remove();
                });
            }else{
                layer.msg("取消分配失败.",{time:1000,icon:5});
            }
        });




    });
























</script>
</body>
</html>
