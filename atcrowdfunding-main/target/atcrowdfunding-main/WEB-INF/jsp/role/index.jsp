<%@ page language="java" contentType="text/html; charset=UTF-8"
         pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="zh-CN">
<head>
    <meta charset="UTF-8">
    <meta http-equiv="X-UA-Compatible" content="IE=edge">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <meta name="description" content="">
    <meta name="author" content="">

   <%@include file="/WEB-INF/jsp/common/css.jsp"%>
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

<div class="container-fluid" id="app">
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
                                <input class="form-control has-success" v-model.trim="condition" type="text" placeholder="请输入查询条件">
                            </div>
                        </div>
                        <button type="button" class="btn btn-warning" @click="allRoles(page.pageNum,page.pageSize,condition)" ><i class="glyphicon glyphicon-search"></i> 查询</button>
                    </form>
                    <button type="button" class="btn btn-danger" style="float:right;margin-left:10px;"><i class=" glyphicon glyphicon-remove"></i> 删除</button>
                    <button type="button" class="btn btn-primary" style="float:right" data-toggle="modal" data-target="#addRoleModel"><i class="glyphicon glyphicon-plus"></i> 新增</button>
                    <br>
                    <hr style="clear:both;">
                    <div class="table-responsive">
                        <table class="table  table-bordered">
                            <thead>
                            <tr >
                                <th width="30">#</th>
                                <th width="30"><input type="checkbox"></th>
                                <th>名称</th>
                                <th width="100">操作</th>
                            </tr>
                            </thead>
                            <tbody>
                            <tr v-for="(role,idx) in page.list">
                                <td>{{idx+1}}</td>
                                <td><input type="checkbox"></td>
                                <td>{{role.name}}</td>
                                <td>
                                    <button type="button" :roleId="role.id" data-toggle="modal" data-target="#assignPermissionToRoleModel" class="assignBtnClass btn btn-success btn-xs"><i class=" glyphicon glyphicon-check"></i></button>
                                    <button type="button"  data-toggle="modal" data-target="#updateRoleModel"  @click="updateRole(role.id)" class="updateBtnClass btn btn-primary btn-xs"><i class=" glyphicon glyphicon-pencil"></i></button>
                                    <button type="button" class="btn btn-danger btn-xs"><i class="deleteBtnClass glyphicon glyphicon-remove" @click="deleteRole(role.id)"></i></button>
                                </td>
                            </tr>

                            </tbody>
                            <tfoot>
                            <tr >
                                <td colspan="6" align="center">
                                    <ul class="pagination">
                                        <li v-if="page.isFirstPage" :class="{disabled: page.isFirstPage}"><a href="javascript:0">上一页</a></li>
                                        <li v-else @click="allRoles(page.prePage,page.pageSize,'')"><a href="javascript:0">上一页</a></li>
                                        <li v-for="n in page.pages" :class="{active: n==page.pageNum}" @click="allRoles(n,page.pageSize,'')"><a href="#">{{n}} <span class="sr-only">(current)</span></a></li>
                                        <li  v-if=" page.isLastPage" :class="{disabled: page.isLastPage}" ><a href="javascript:0">下一页</a></li>
                                        <li v-else  @click="allRoles(page.nextPage,page.pageSize,'')"><a href="javascript:0">下一页</a></li>

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
    <!-- 添加角色 模态框 -->
    <div id="addRoleModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">添加角色</h4>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label for="name">角色名称</label>
                        <input id="name" type="text" class="form-control" name="name" v-model.trim="role.name" placeholder="请输入角色名称">
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button  type="button" class="btn btn-primary" v-on:click="saveRole()">保存</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->


    !-- 修改角色 模态框 -->
    <div id="updateRoleModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">修改角色</h4>
                </div>
                <div class="modal-body">

                    <div class="form-group">
                        <label for="name">角色名称</label>
                        <input type="hidden" name="id" v-model.trim="role.id">
                        <input type="text" class="form-control" v-model.trim="role.name" name="name" placeholder="请输入角色名称">
                    </div>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="updateBtn" type="button" class="btn btn-primary" @click="updateSave()">修改</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->


    <!-- 给角色分配权限(许可) 模态框 -->
    <div id="assignPermissionToRoleModel" class="modal fade">
        <div class="modal-dialog">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
                    <h4 class="modal-title">给角色分配权限(许可)</h4>
                </div>
                <div class="modal-body">
                    <input type="hidden" name="roleId" >
                    <ul id="treeDemo" class="ztree"></ul>

                </div>
                <div class="modal-footer">
                    <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
                    <button id="assignBtn" type="button" class="btn btn-primary">分配</button>
                </div>
            </div><!-- /.modal-content -->
        </div><!-- /.modal-dialog -->
    </div><!-- /.modal -->

</div>






<%@include file="/WEB-INF/jsp/common/js.jsp"%>
<script type="text/javascript">



        var app=new Vue({
            el:'#app',
            data:{
               page:{},
                condition: "",
                roleName:"",
                roleId:"",
                role:{
                }
            },
            methods:{
                allRoles:function(pageNum,pageSize,condition){
                    axios.get('${PATH}/role/allRoles',{

                        params:{
                            pageNum,
                            pageSize,
                            condition
                        }
                    }).then(response=>{
                        this.page=response.data
                    })

                },
                saveRole:function () {
                    axios.post('${PATH}/role/save',this.role).then(response=>{
                       console.log(response);
                        if(response.data=="ok"){
                            this.allRoles();
                            layer.msg("保存成功",{time:1000,icon:6});
                            $("#addRoleModel").modal("hide");
                        }else if (response.data=="403"){
                            layer.msg("没有权限",{time:1000,icon:5});
                            $("#addRoleModel").modal("hide");
                        }
                        else {
                            layer.msg("保存失败",{time:1000,icon:5});
                            $("#addRoleModel").modal("hide");
                        }

                    })
                },
                updateRole:function (roleId) {
                    axios.get('${PATH}/role',{
                       params: {
                           id:roleId
                       }
                    }).then(response=>{
                        this.role=response.data
                    })
                },
                deleteRole:function(roleId){
                    layer.confirm("确认要删除吗?",{btn:["确定","取消"]},
                    function (index) {
                        axios.delete('${PATH}/role/delete',{
                            params:{
                                id:roleId
                            }
                        }).then(response=>{
                            console.info(response);
                            if(response.data=="ok"){
                                layer.msg("删除成功",{time:1000,icon:6});
                                app.allRoles();
                                layer.close(index);
                            }else {
                                layer.msg("删除失败",{time:1000,icon:5});

                            }
                        }

                        );
                    }, function (index) {
                        layer.close(index);
                        }
                    );

                },
                updateSave:function(){
                    axios.post('${PATH}/role/update',this.role).then(response=>{
                        console.log(response);
                        if(response.data=="ok"){
                            this.allRoles();
                            layer.msg("保存成功",{time:1000,icon:6});
                            $("#updateRoleModel").modal("hide");
                        }else {
                            layer.msg("保存失败",{time:1000,icon:5});
                            $("#updateRoleModel").modal("hide");
                        }

                    })
                },

            },


            created(){
                this.allRoles()
            },
            mounted () {
                this.allRoles()
            }


    });
</script>
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

    $("tbody .btn-success").click(function(){
        window.location.href = "assignPermission.html";
    });

    //~~~~~~~~~分配   开始~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
    $("tbody").on("click",".assignBtnClass",function(){

        var roleId = $(this).attr("roleId");
        console.log(roleId);
        $("#assignPermissionToRoleModel input[name='roleId']").val(roleId);

        initTree(roleId);

       /* $("#assignPermissionToRoleModel").modal({
            show:true,
            backdrop:'static',
            keyboard:false
        });*/

    });


    function initTree(roleId){

        var setting = {
            data: {
                simpleData: {
                    enable: true,
                    pIdKey: "pid"
                },
                key: {
                    url: "xUrl",
                    name:"title"
                }
            },
            view: {
                addDiyDom: addDiyDom
            },
            check:{
                enable:true
            }
        };

        //多个异步请求，执行返回顺序问题？

        //1.加载数据
        $.get("${PATH}/permission/listAllPermissionTree",function(data){
            //data.push({"id":0,"title":"系统权限","icon":"glyphicon glyphicon-asterisk"});

            var tree = $.fn.zTree.init($("#treeDemo"), setting, data);
            var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            treeObj.expandAll(true);


            //2.回显数据
            $.get("${PATH}/role/listPermissionIdByRoleId",{roleId:roleId},function(data){	 // List<Integer> 被分配过的许可id
                $.each(data,function(i,e){
                    var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
                    var node = treeObj.getNodeByParam("id", e, null);  //第三个参数表示从哪个父节点进行查找，为null表示从整颗树进行查找
                    treeObj.checkNode(node, true, false, false);
                });
            });
        });

    }

    function addDiyDom(treeId,treeNode){
        $("#"+treeNode.tId+"_ico").removeClass();
        $("#"+treeNode.tId+"_span").before('<span class="'+treeNode.icon+'"></span>');
    }

    $("#assignBtn").click(function(){
        var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
        var checkedBoxList = treeObj.getCheckedNodes(true);

        var roleId = $("#assignPermissionToRoleModel input[name='roleId']").val();

        var json = {
            roleId:roleId
        };

        $.each(checkedBoxList,function(i,e){
            var permissionId = e.id;
            json['ids['+i+']'] = permissionId
        });

        console.log(json);

        $.post("${PATH}/role/doAssign",json,function(result){
            if(result=="ok"){
                layer.msg("分配成功.",{time:1000,icon:6},function(){
                    $("#assignPermissionToRoleModel").modal('hide');
                });
            }else{
                layer.msg("分配失败.",{time:1000,icon:5});
            }
        });
    });
</script>
</body>
</html>
