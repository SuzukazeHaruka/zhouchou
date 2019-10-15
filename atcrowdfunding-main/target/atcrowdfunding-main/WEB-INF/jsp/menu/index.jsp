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

  <body >

    <jsp:include page="/WEB-INF/jsp/common/top.jsp"></jsp:include>

    <div class="container-fluid">
      <div class="row">
        <jsp:include page="/WEB-INF/jsp/common/sidebar.jsp"></jsp:include>
        <div class="col-sm-9 col-sm-offset-3 col-md-10 col-md-offset-2 main">
			<div class="panel panel-default">
			  <div class="panel-heading">
				<h3 class="panel-title"><i class="glyphicon glyphicon-th"></i> 菜单树</h3>
			  </div>
			  <div class="panel-body">
					<ul id="treeDemo" class="ztree"></ul>
			  </div>
			</div>
        </div>
      </div>
    </div>



<!-- 添加菜单 模态框 -->
<div id="addMenuModel" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">添加菜单</h4>
      </div>
      <div class="modal-body">

		  <div class="form-group">
			<label for="name">菜单名称</label>
			<input type="hidden" name="pid">
			<input type="text" class="form-control" name="name" placeholder="请输入菜单名称">
		  </div>
		  <div class="form-group">
			<label for="name">菜单图标</label>
			<input type="text" class="form-control" name="icon" placeholder="请输入菜单图标">
		  </div>
		  <div class="form-group">
			<label for="name">菜单URL</label>
			<input type="text" class="form-control" name="url" placeholder="请输入菜单URL">
		  </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="saveBtn" type="button" class="btn btn-primary">保存</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->






<!-- 修改菜单 模态框 -->
<div id="updateMenuModel" class="modal fade">
  <div class="modal-dialog">
    <div class="modal-content">
      <div class="modal-header">
        <button type="button" class="close" data-dismiss="modal" aria-label="Close"><span aria-hidden="true">&times;</span></button>
        <h4 class="modal-title">修改菜单</h4>
      </div>
      <div class="modal-body">

		  <div class="form-group">
			<label for="name">菜单名称</label>
			<input type="hidden" name="id">
			<input type="text" class="form-control" name="name" placeholder="请输入菜单名称">
		  </div>
		  <div class="form-group">
			<label for="name">菜单图标</label>
			<input type="text" class="form-control" name="icon" placeholder="请输入菜单图标">
		  </div>
		  <div class="form-group">
			<label for="name">菜单URL</label>
			<input type="text" class="form-control" name="url" placeholder="请输入菜单URL">
		  </div>

      </div>
      <div class="modal-footer">
        <button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
        <button id="updateBtn" type="button" class="btn btn-primary">修改</button>
      </div>
    </div><!-- /.modal-content -->
  </div><!-- /.modal-dialog -->
</div><!-- /.modal -->







    <%@ include file="/WEB-INF/jsp/common/js.jsp" %>
        <script type="text/javascript">
            $(function () {  // ready事件，当前页面被浏览器加载完成时触发的事件。
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


            	initTree();
            });

            function initTree(){
            	var setting = {
               		data: {
           				simpleData: {
           					enable: true,
           					pIdKey:"pid"
           				}
           			},
           			view:{
           				addDiyDom: function(treeId, treeNode){
           					$("#"+treeNode.tId+"_ico").removeClass();//.addClass();
           					$("#"+treeNode.tId+"_span").before("<span class='"+treeNode.icon+"'></span>");
						},
						addHoverDom: function(treeId, treeNode){  //鼠标移动到节点上时触发的事件     treeNode就想到与后台TMenu对象。
							var aObj = $("#" + treeNode.tId + "_a");
							aObj.attr("href", "javascript:void(0)"); //禁用href属性。

							//如果有按钮组存在，就结束函数
							if (treeNode.editNameFlag || $("#btnGroup"+treeNode.tId).length>0) return;

							//否则，就在节点连接后增加按钮组
							var s = '<span id="btnGroup'+treeNode.tId+'">';
							if ( treeNode.level == 0 ) { //根节点
								s += '<a class="btn btn-info dropdown-toggle btn-xs"  style="margin-left:10px;padding-top:0px;" onclick="addBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
							} else if ( treeNode.level == 1 ) { //分支节点
								s += '<a class="btn btn-info dropdown-toggle btn-xs"  style="margin-left:10px;padding-top:0px;" onclick="updateBtn('+treeNode.id+')"  title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
								if (treeNode.children.length == 0) { //该节点没有孩子节点，可以删除
									s += '<a class="btn btn-info dropdown-toggle btn-xs"  style="margin-left:10px;padding-top:0px;" onclick="deleteBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
								}
								s += '<a class="btn btn-info dropdown-toggle btn-xs"   style="margin-left:10px;padding-top:0px;" onclick="addBtn('+treeNode.id+')" >&nbsp;&nbsp;<i class="fa fa-fw fa-plus rbg "></i></a>';
							} else if ( treeNode.level == 2 ) { //叶子节点
								s += '<a class="btn btn-info dropdown-toggle btn-xs"  style="margin-left:10px;padding-top:0px;"  onclick="updateBtn('+treeNode.id+')" title="修改权限信息">&nbsp;&nbsp;<i class="fa fa-fw fa-edit rbg "></i></a>';
								s += '<a class="btn btn-info dropdown-toggle btn-xs"  style="margin-left:10px;padding-top:0px;" onclick="deleteBtn('+treeNode.id+')">&nbsp;&nbsp;<i class="fa fa-fw fa-times rbg "></i></a>';
							}
							s += '</span>';
							aObj.after(s);
						},
						removeHoverDom: function(treeId, treeNode){ //鼠标离开节点时触发的事件
							$("#btnGroup"+treeNode.tId).remove();
						}

           			}
                };


            	$.get("${PATH}/menu/loadTree",{},function(result){
            		 var zNodes = result;
            		 zNodes.push({id:0,name:"系统菜单",icon:"glyphicon glyphicon-th-list"});

            		 var treeObj = $.fn.zTree.init($("#treeDemo"), setting, zNodes);

            		 //var treeObj = $.fn.zTree.getZTreeObj("treeDemo");
            		 treeObj.expandAll(true);
            	});




            }


            //-------添加 开始-------------------------------------------------------

            function addBtn(id){
            	var pid = id ;
            	$("#addMenuModel input[name='pid']").val(pid);

            	$("#addMenuModel").modal({
            		show:true,
            		backdrop:'static',
            		keyboard:false
            	});

            }

            $("#saveBtn").click(function(){
				var name = $("#addMenuModel input[name='name']").val();
				var icon = $("#addMenuModel input[name='icon']").val();
				var url = $("#addMenuModel input[name='url']").val();
				var pid = $("#addMenuModel input[name='pid']").val();

            	$.ajax({
            		type:"post",
            		url:"${PATH}/menu/doAdd",
            		data:{
            			name:name,
            			icon:icon,
            			url:url,
            			pid:pid
            		},
            		success:function(result){
            			if(result=="ok"){
            				layer.msg("保存成功.",{time:1000,icon:6});
            				$("#addMenuModel").modal("hide");
            				initTree();

            			    $("#addMenuModel input[name='name']").val("");
            				$("#addMenuModel input[name='icon']").val("");
            				$("#addMenuModel input[name='url']").val("");
            				$("#addMenuModel input[name='pid']").val("");
            			}else{
            				layer.msg("保存失败.",{time:1000,icon:5});
            			}
            		}
            	});
            });

            //-------添加 结束-------------------------------------------------------


             //-------修改 开始-------------------------------------------------------

            function updateBtn(id){
            	$.ajax({
            		type:"post",
            		url:"${PATH}/menu/get",
            		data:{
            			id:id
            		},
            		success:function(result){
            			$("#updateMenuModel input[name='name']").val(result.name);
        				$("#updateMenuModel input[name='icon']").val(result.icon);
        				$("#updateMenuModel input[name='url']").val(result.url);
        				$("#updateMenuModel input[name='id']").val(result.id);

            			$("#updateMenuModel").modal({
                    		show:true,
                    		backdrop:'static',
                    		keyboard:false
                    	});
            		}
            	});

            }


            $("#updateBtn").click(function(){
				var name = $("#updateMenuModel input[name='name']").val();
				var icon = $("#updateMenuModel input[name='icon']").val();
				var url = $("#updateMenuModel input[name='url']").val();
				var id = $("#updateMenuModel input[name='id']").val();

            	$.ajax({
            		type:"post",
            		url:"${PATH}/menu/doUpdate",
            		data:{
            			name:name,
            			icon:icon,
            			url:url,
            			id:id
            		},
            		success:function(result){
            			if(result=="ok"){
            				layer.msg("修改成功.",{time:1000,icon:6});
            				$("#updateMenuModel").modal("hide");
            				initTree();
            			}else{
            				layer.msg("修改失败.",{time:1000,icon:5});
            			}
            		}
            	});
            });
    		
            //-------修改 结束-------------------------------------------------------
            
            //-------删除 开始-------------------------------------------------------
            
            function deleteBtn(id){            	
            	layer.confirm("确定要删除吗？",{btn:["确定","取消"]},function(index){
            		$.post("${PATH}/menu/delete",{id:id},function(result){
                		if(result=="ok"){
             				layer.msg("删除成功.",{time:1000,icon:6}); 			
             				
             				initTree();
             			}else{
             				layer.msg("删除失败.",{time:1000,icon:5});
             			}
                	});
            		
            		layer.close(index);
            	},function(index){
            		layer.close(index);
            	});
            }
    		
            //-------删除 结束-------------------------------------------------------
            
            
        </script>
  </body>
</html>
    