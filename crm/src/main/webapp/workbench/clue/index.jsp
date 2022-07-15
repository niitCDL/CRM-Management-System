<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%
String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />
<link href="jquery/bootstrap-datetimepicker-master/css/bootstrap-datetimepicker.min.css" type="text/css" rel="stylesheet" />

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>

<script type="text/javascript">

	$(function(){
		pageList(1,2)
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-right"
		});

		$("#addBtn").click(function () {
			var id="${user.id}";
			$("#create-owner option").remove();
			$.ajax({
				url:"workbench/clue/getUserList.do",
				dataType:"json",
				type:"GET",
				success:function (data) {
					$.each(data,function (index,ele) {
						$("#create-owner").append(new Option(ele.name,ele.id));
					})
					$("#create-owner").val(id);
				}
			})
			$("#createClueModal").modal("show");
		})
		
		$("#saveBtn").click(function () {
			var company=$.trim($("#create-company").val());
			var fullname=$.trim($("#create-fullname").val());
			if(company==null||company==""){
				alert("公司名称不能为空");
				return
			}
			if(fullname==null||fullname==""){
				alert("姓名不能为空");
				return
			}
			$.ajax({
				url: "workbench/clue/save.do",
				data:{
					fullname:$.trim($("#create-fullname").val()),
					appellation:$.trim($("#create-appellation").val()),
					owner:$.trim($("#create-owner").val()),
					company:$.trim($("#create-company").val()),
					job:$.trim($("#create-job").val()),
					email:$.trim($("#create-email").val()),
					phone:$.trim($("#create-phone").val()),
					website:$.trim($("#create-website").val()),
					mphone:$.trim($("#create-mphone").val()),
					state:$.trim($("#create-state").val()),
					source:$.trim($("#create-source").val()),
					description:$.trim($("#create-description").val()),
					contactSummary:$.trim($("#create-contactSummary").val()),
					nextContactTime:$.trim($("#create-nextContactTime").val()),
					address:$.trim($("#create-address").val())
				},
				type:"POST",
				dataType: "json",
				success:function (data) {
					if(data.success){
						pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'));
						$("#clueForm")[0].reset();
						$("#createClueModal").modal("hide");
					}else {
						alert("添加市场活动失败!");
					}
				}
			})
		})

		$("#openUpdateModalBtn").click(function () {
			if($("input[name=xz]:checked").length==0){
				alert("请选择需要修改的记录");
				return;
			}
			if($("input[name=xz]:checked").length>1){
				alert("只能选择一个");
				return;
			}
			var id=$("input[name=xz]:checked").val();

			$("#edit-owner option").remove();
			$.ajax({
				url:"workbench/activity/getUserList.do",
				dataType:"json",
				type:"GET",
				success:function (data) {
					$.each(data,function (index,ele) {
						$("#edit-owner").append(new Option(ele.name,ele.id));
					})
				}
			})

			$.ajax({
				url:"workbench/clue/getClueById.do",
				data:{id:id},
				dataType:"json",
				type:"GET",
				success:function (data) {
					$("#edit-owner").val(data.owner);
					$("#edit-fullname").val(data.fullname),
					$("#edit-appellation").val(data.appellation),
					$("#edit-company").val(data.company),
					$("#edit-job").val(data.job),
					$("#edit-email").val(data.email),
					$("#edit-phone").val(data.phone),
					$("#edit-website").val(data.website),
					$("#edit-mphone").val(data.mphone),
					$("#edit-state").val(data.state),
					$("#edit-source").val(data.source),
					$("#edit-description").val(data.description),
					$("#edit-contactSummary").val(data.contactSummary),
					$("#edit-nextContactTime").val(data.nextContactTime),
					$("#edit-address").val(data.address)
				}
			})
			$("#editClueModal").modal("show");
		})

		$("#queryClueBtn").click(function () {
			$("#hidden-fullname").val($("#search-fullname").val());
			$("#hidden-owner").val($("#search-owner").val());
			$("#hidden-company").val($("#search-company").val());
			$("#hidden-source").val($("#search-source").val());
			$("#hidden-state").val($("#search-state").val());
			$("#hidden-phone").val($("#search-phone").val());
			$("#hidden-mphone").val($("#search-mphone").val());
			pageList(1,$("#cluePage").bs_pagination('getOption', 'rowsPerPage'))
		})

		$("#updateClueBtn").click(function () {
			$.ajax({
				url:"workbench/clue/update.do",
				type:"POST",
				data:{
					id: $("input[name=xz]:checked").val(),
					fullname:$("#edit-fullname").val(),
					appellation:$("#edit-appellation").val(),
					owner:$("#edit-owner").val(),
					company:$("#edit-company").val(),
					job:$("#edit-job").val(),
					email:$("#edit-email").val(),
					phone:$("#edit-phone").val(),
					website:$("#edit-website").val(),
					mphone:$("#edit-mphone").val(),
					state:$("#edit-state").val(),
					source:$("#edit-source").val(),
					description:$("#edit-description").val(),
					contactSummary:$("#edit-contactSummary").val(),
					nextContactTime:$("#edit-nextContactTime").val(),
					address:$("#edit-address").val()
				},
				success:function (data) {
					if(data.success){
						pageList($("#cluePage").bs_pagination('getOption', 'currentPage'),
								$("#cluePage").bs_pagination('getOption', 'rowsPerPage'))
						$("#editClueModal").modal("hide");
					}else {
						alert("修改失败");
					}
				}
			})
		})

		$("#delBtn").click(function () {
			var idList=$("input[name=xz]:checked");
			if(idList.length==0){
				alert("请选中要删除的记录");
				return;
			}
			var param="";
			$.each(idList,function (index,ele) {
				param+="id="+ele.value;
				if(index<idList.length-1){
					param+="&";
				}
			})
			if(confirm("确定要删除这些线索吗?")){
				$.ajax({
					url:"workbench/clue/delete.do",
					data:param,
					type:"POST",
					success:function (data) {
						if(data.success){
							pageList(1,
									$("#cluePage").bs_pagination('getOption', 'rowsPerPage'))
						}else {
							alert("删除失败");
						}
					}
				})
			}
		})



		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})
		
		$("#clueBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		
	});


	function pageList(pageNo,pageSize){

		$("#qx").prop("checked",false);
		var html="";
		$("#search-fullname").val($("#hidden-fullname").val());
		$("#search-owner").val($("#hidden-owner").val());
		$("#search-company").val($("#hidden-company").val());
		$("#search-source").val($("#hidden-source").val());
		$("#search-state").val($("#hidden-state").val());
		$("#search-phone").val($("#hidden-phone").val());
		$("#search-mphone").val($("#hidden-mphone").val());
		$.ajax({
			url:"workbench/clue/pageList.do",
			type: "GET",
			data: {
				pageNo:pageNo,
				pageSize:pageSize,
				fullname:$("#search-fullname").val(),
				owner:$("#search-owner").val(),
				company:$("#search-company").val(),
				phone:$("#search-phone").val(),
				mphone:$("#search-mphone").val(),
				state:$("#search-state").val(),
				source:$("#search-source").val()
			},
			dataType:"json",
			success:function (data) {
				$.each(data.activities,function (index,ele) {
					html+='<tr class="active">'
					html+='<td><input type="checkbox" name="xz" value="'+ele.id+'"/></td>'
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/clue/detail.do?id='+ele.id+'\';">'+ele.fullname+'</a></td>'
					html+='<td>'+ele.company+'</td>'
					html+='<td>'+ele.phone+'</td>'
					html+='<td>'+ele.mphone+'</td>'
					html+='<td>'+ele.source+'</td>'
					html+='<td>'+ele.owner+'</td>'
					html+='<td>'+ele.state+'</td>'
					html+='</tr>'
				})
				$("#clueBody").html(html);
				var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#cluePage").bs_pagination({
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

	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-company">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-mphone">
	<input type="hidden" id="hidden-phone">
	<input type="hidden" id="hidden-state">
	<!-- 创建线索的模态窗口 -->
	<div class="modal fade" id="createClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">创建线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="clueForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">

								</select>
							</div>
							<label for="create-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-company">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
									<option></option>
									<c:forEach items="${applicationScope.appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-phone">
							</div>
							<label for="create-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-website">
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
							<label for="create-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-state">
									<option></option>
									<c:forEach items="${applicationScope.clueStateList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
									<option></option>
									<c:forEach items="${applicationScope.sourceList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						

						<div class="form-group">
							<label for="create-description" class="col-sm-2 control-label">线索描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="create-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="create-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="create-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time" id="create-nextContactTime">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>
						
						<div style="position: relative;top: 20px;">
							<div class="form-group">
                                <label for="create-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
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
	
	<!-- 修改线索的模态窗口 -->
	<div class="modal fade" id="editClueModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 90%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">修改线索</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="edit-company" class="col-sm-2 control-label">公司<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-company" value="动力节点">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellationList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job" value="CTO">
							</div>
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email" value="lisi@bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-phone" value="010-84846003">
							</div>
							<label for="edit-website" class="col-sm-2 control-label">公司网站</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-website" value="http://www.bjpowernode.com">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone" value="12345678901">
							</div>
							<label for="edit-state" class="col-sm-2 control-label">线索状态</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-state">
								  <option></option>
									<c:forEach items="${applicationScope.clueStateList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-source" class="col-sm-2 control-label">线索来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${applicationScope.sourceList}" var="a">
										<option value="${a.value}">${a.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description">这是一条线索的描述信息</textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary">这个线索即将被转换</textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control" id="edit-nextContactTime" value="2017-05-01">
								</div>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative; top : 10px;"></div>

                        <div style="position: relative;top: 20px;">
                            <div class="form-group">
                                <label for="edit-address" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴区大族企业湾</textarea>
                                </div>
                            </div>
                        </div>
<%--						<div class="modal-footer">
							<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
							<button type="submit" class="btn btn-primary" data-dismiss="modal">更新</button>
						</div>--%>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="updateClueBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	
	
	
	
	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>线索列表</h3>
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
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司</div>
				      <input class="form-control" type="text" id="search-company">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">公司座机</div>
				      <input class="form-control" type="text" id="search-phone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索来源</div>
					  <select class="form-control" id="search-source">
					  	  <option></option>
						  <c:forEach items="${applicationScope.sourceList}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">手机</div>
				      <input class="form-control" type="text" id="search-mphone">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">线索状态</div>
					  <select class="form-control" id="search-state">
					  	<option></option>
						  <c:forEach items="${applicationScope.clueStateList}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>

				  <button type="button" class="btn btn-default" id="queryClueBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 40px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" id="addBtn" data-target="#createClueModal"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" id="openUpdateModalBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 50px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>公司</td>
							<td>公司座机</td>
							<td>手机</td>
							<td>线索来源</td>
							<td>所有者</td>
							<td>线索状态</td>
						</tr>
					</thead>
					<tbody id="clueBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 60px;">
				<div id="cluePage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>