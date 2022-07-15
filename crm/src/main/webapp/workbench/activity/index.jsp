<%@ page import="com.bjpowernode.crm.settings.domain.User" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
	User user= (User) session.getAttribute("user");
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>


<script type="text/javascript">



	$(function(){
		pageList(1,2);

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$("#addBtn").click(function () {
			var id="${user.id}";
			$("#create-owner option").remove();
			$.ajax({
				url:"workbench/activity/getUserList.do",
				dataType:"json",
				type:"GET",
				success:function (data) {
					$.each(data,function (index,ele) {
						$("#create-owner").append(new Option(ele.name,ele.id));
					})
					$("#create-owner").val(id);
				}
			})
			$("#createActivityModal").modal("show");
		})

		$("#saveBtn").click(function () {
			var owner=$.trim($("#create-owner").val());
			var name=$.trim($("#create-name").val());
			if(owner==null||owner==""){
				alert("所有者不能为空");
				return;
			}
			if(name==null||name==""){
				alert("市场活动名称不能为空");
				return;
			}
			$.ajax({
				url: "workbench/activity/save.do",
				data:{
					owner:$.trim($("#create-owner").val()),
					name:$.trim($("#create-name").val()),
					startDate:$.trim($("#create-startDate").val()),
					endDate:$.trim($("#create-endDate").val()),
					cost:$.trim($("#create-cost").val()),
					description:$.trim($("#create-description").val())
				},
				dataType: "json",
				success:function (data) {
					if(data.success){
						pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
						// $("#addActivityForm")[0].reset();
						$("#createActivityModal").modal("hide");
					}else {
						alert("添加市场活动失败!");
					}
				}
			})
		})

		$("#editBtn").click(function () {
			var $xz=$("input[name=xz]:checked");
			var id=$xz.val();
			if($xz.length<1){
				alert("请选中你要修改的记录")
			}else if($xz.length>1){
				alert("只能选择一条修改的记录")
			}else {
				$.ajax({
					url: "workbench/activity/getUserListandActivity.do",
					data:{
						"id":id
					},
					dataType: "json",
					success:function (data) {
						$("#edit-owner")[0].length=0;
						$.each(data.userList,function (index,ele) {
							$("#edit-owner").append(new Option(ele.name,ele.id));
							if(data.activity.owner==ele.name){
								$("#edit-owner").val(ele.id);
							}
						})
						var a=data.activity;
						$("#edit-name").val(a.name);
						$("#edit-startDate").val(a.startDate);
						$("#edit-endDate").val(a.endDate);
						$("#edit-cost").val(a.cost);
						$("#edit-description").val(a.description);
						$("#edit-id").val(a.id);
					}
				})
				$("#editActivityModal").modal("show");
			}
		})
		
		$("#updateBtn").click(function () {
			if(confirm("确定需要修改记录?")){
				$.ajax({
					url: "workbench/activity/update.do",
					data:{
						id:$.trim($("#edit-id").val()),
						owner:$.trim($("#edit-owner").val()),
						name:$.trim($("#edit-name").val()),
						startDate:$.trim($("#edit-startDate").val()),
						endDate:$.trim($("#edit-endDate").val()),
						cost:$.trim($("#edit-cost").val()),
						description:$.trim($("#edit-description").val()),
						editBy:$.trim($("#edit-owner option:selected").text())
					},
					dataType: "json",
					type:"post",
					success:function (data) {
						if(data.success){
							pageList($("#activityPage").bs_pagination('getOption', 'currentPage')
									,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							$("#editActivityModal").modal("hide");
						}else {
							alert("修改市场活动失败!");
						}
					}
				})
			}
		})
		
		$("#searchBtn").click(function () {
			$("#hidden-name").val($.trim($("#search-name").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-startDate").val($.trim($("#search-startDate").val()));
			$("#hidden-endDate").val($.trim($("#search-endDate").val()));
			pageList(1,2);
		})
		
		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})

		$("#activityTbody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		
		$("#delBtn").click(function () {
			var param="";
			var $xz=$("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择你要删除的记录")
			}else {
				if(confirm("活动可能涉及到交易内容,确定要删除吗?")){
					$.each($xz,function (index,ele) {
						param+="id="+ele.value+"&";
					})
					param=param.substring(0,param.length-1);
					$.ajax({
						url: "workbench/activity/delete.do",
						data:param,
						type:"POST",
						dataType: "json",
						success:function (data) {
							if(data.success){
								pageList(1,$("#activityPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("删除市场活动失败!");
							}
						}
					})
				}
			}
		})



	});


	function pageList(pageNo,pageSize){

		$("#qx").prop("checked",false);
		$("#search-name").val($.trim($("#hidden-name").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-startDate").val($.trim($("#hidden-startDate").val()));
		$("#search-endDate").val($.trim($("#hidden-endDate").val()));

		var html="";
		$.ajax({
			url:"workbench/activity/pageList.do",
			type: "GET",
			data: {
			    pageNo:pageNo,
                pageSize:pageSize,
                owner:$("#search-owner").val(),
                name:$("#search-name").val(),
                startDate:$("#search-startDate").val(),
                endDate:$("#search-endDate").val()
			},
			dataType:"json",
			success:function (data) {
				$.each(data.activities,function (index,ele) {
                    html+='<tr class="active">';
                    html+='<td><input type="checkbox" name="xz" value="'+ele.id+'"/></td>';
                    html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/activity/detail.do?id='+ele.id+'\';">'+ele.name+'</a></td>';
                    html+='<td>'+ele.owner+'</td>';
                    html+='<td>'+ele.startDate+'</td>';
                    html+='<td>'+ele.endDate+'</td>';
                    html+='</tr>';
				})
				$("#activityTbody").html(html);
				var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#activityPage").bs_pagination({
					currentPage: pageNo, // 页码
					rowsPerPage: pageSize, // 每页显示的记录条数
					maxRowsPerPage: 20, // 每页最多显示的记录条数
					totalPages: totalPages, // 总页数
					totalRows: data.total, // 总记录条数

					visiblePageLinks: 3, // 显示几个卡片

					showGoToPage: true,
					showRowsPerPage: true,
					showRowsInfo: true,
					showRowsDefaultInfo: true,

					onChangePage : function(event, data){
						pageList(data.currentPage , data.rowsPerPage);
					}
				});


			}
		})
	}

</script>
</head>
<body>

	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-startDate">
	<input type="hidden" id="hidden-endDate">
	<!-- 创建市场活动的模态窗口 -->
	<div class="modal fade" id="createActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" id="addActivityForm" role="form">

						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<%--所有者下拉框--%>
								<select class="form-control" id="create-owner">

								</select>
							</div>
                            <label for="create-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="create-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-startDate">
							</div>
							<label for="create-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-endDate">
							</div>
						</div>
                        <div class="form-group">

                            <label for="create-cost" class="col-sm-2 control-label">成本</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="create-cost">
                            </div>
                        </div>
						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveBtn">保存</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动的模态窗口 -->
	<div class="modal fade" id="editActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel2">修改市场活动</h4>
				</div>
				<div class="modal-body">

					<form class="form-horizontal" role="form">

						<input type="hidden" id="edit-id">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
                            <label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-name">
                            </div>
						</div>

						<div class="form-group">
							<label for="edit-startDate" class="col-sm-2 control-label">开始日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-startDate">
							</div>
							<label for="edit-endDate" class="col-sm-2 control-label">结束日期</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-endDate">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-cost" class="col-sm-2 control-label">成本</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-cost">
							</div>
						</div>

						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">市场活动Marketing，是指品牌主办或参与的展览会议与公关市场活动，包括自行主办的各类研讨会、客户交流会、演示会、新产品发布会、体验会、答谢会、年会和出席参加并布展或演讲的展览会、研讨会、行业交流会、颁奖典礼等</textarea>
							</div>
						</div>

					</form>

				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>




	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>市场活动列表</h3>
			</div>
		</div>
	</div>
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">

			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>

				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>


				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">开始日期</div>
					  <input class="form-control" type="text" id="search-startDate" />
				    </div>
				  </div>
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">结束日期</div>
					  <input class="form-control" type="text" id="search-endDate">
				    </div>
				  </div>

				  <button type="button" id="searchBtn" class="btn btn-default">查询</button>

				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 5px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>

			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
                            <td>所有者</td>
							<td>开始日期</td>
							<td>结束日期</td>
						</tr>
					</thead>
					<tbody id="activityTbody">

					</tbody>
				</table>
			</div>

			<div style="height: 50px; position: relative;top: 20px;">
				<div id="activityPage"></div>
			</div>

		</div>

	</div>
</body>
</html>