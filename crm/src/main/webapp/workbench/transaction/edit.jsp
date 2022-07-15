<%@ page import="java.util.Map" %>
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
	<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>
</head>
<script>
	$(function () {
		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		$(".time1").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		showTransactionMsg();

		$("#cancelBtn").click(function () {
			window.location.href="workbench/transaction/detail.do?id=${t.id}";
		})

		$("#edit-customerName").typeahead({
			source: function (query, process) {
				$.post(
						"workbench/transaction/getCustomerName.do",
						{ "name" : query },
						function (data) {
							process(data);
						},
						"json"
				);
			},
			delay: 1500
		});

		$("#edit-stage").change(function () {
			var stage=$("#edit-stage :selected").text();
			$.ajax({
				url:"workbench/transaction/getPossibility.do",
				data:{
					stage:stage
				},
				success:function (data) {
					$("#edit-possibility").val(data);
				}
			})
		})

		$("#findActivityBtn").click(function () {
			$("#activitySearchCondition").val("")
			$("#activitySearchBody").html("");
			$("#findMarketActivity").modal("show")
		})

		$("#activitySearchCondition").keydown(function (event) {
			if(event.keyCode=="13"){
				var html="";
				$.ajax({
					url:"workbench/transaction/getActivityByName.do",
					data:{
						aid:$("#edit-activityId").val(),
						aname:$("#activitySearchCondition").val()
					},
					dataType:"json",
					type:"GET",
					success:function (data) {
						$.each(data,function (index,ele) {
							html+='<tr>';
							html+='	<td><input type="radio" name="activity" value="'+ele.id+'"/></td>';
							html+='	<td id="a'+ele.id+'">'+ele.name+'</td>';
							html+='	<td>'+ele.startDate+'</td>';
							html+='	<td>'+ele.endDate+'</td>';
							html+='	<td>'+ele.owner+'</td>';
							html+='</tr>';
						})
						$("#activitySearchBody").html(html);
					}
				})
				return false;
			}
		})

		$("#bundBtn").click(function () {
			var obj=$("input[name=activity]:checked")
			$("#edit-activityName").val($("#a"+obj.val()).html());
			$("#edit-activityId").val(obj.val());
			$("#findMarketActivity").modal("hide");
		})

		$("#update").click(function () {
			var owner=$.trim($("#edit-owner").val());
			var name=$.trim($("#edit-name").val());
			var expectedDate=$.trim($("#edit-expectedDate").val());
			var customerName=$.trim($("#edit-customerName").val());
			var stage=$.trim($("#edit-stage").val());
			if(owner==null||owner==""){
				alert("所有者不能为空")
				return;
			}
			if(name==null||name==""){
				alert("交易名称不能为空")
				return;
			}
			if(expectedDate==null||expectedDate==""){
				alert("期望日期不能为空")
				return;
			}
			if(customerName==null||customerName==""){
				alert("客户名称不能为空")
				return;
			}
			if(stage==null||stage==""){
				alert("交易阶段不能为空")
				return;
			}

			$.ajax({
				url:"workbench/transaction/update.do",
				data:{
					id:"${t.id}",
					owner:$("#edit-owner").val(),
					money:$("#edit-money").val(),
					name:$("#edit-name").val(),
					expectedDate:$("#edit-expectedDate").val(),
					customerName:$("#edit-customerName").val(),
					stage:$("#edit-stage").val(),
					type:$("#edit-type").val(),
					source:$("#edit-source").val(),
					activityId:$("#edit-activityId").val(),
					contactsId:$("#edit-contactId").val(),
					description:$("#edit-description").val(),
					contactSummary:$("#edit-contactSummary").val(),
					nextContactTime:$("#edit-nextContactTime").val()
				},
				type:"POST",
				success:function (data) {
					if(data.success){
						window.location.href="workbench/transaction/detail.do?id=${t.id}";
					}else {
						alert("更新失败!");
					}
				}
			})
		})

		$("#openContactsBtn").click(function () {
			$("#contactSearchCondition").val("");
			$("#contactsBody").html("");
			$("#findContacts").modal("show")
		})

		$("#contactSearchCondition").keydown(function (event) {
			var html="";
			if(event.keyCode=="13"){
				$.ajax({
					url:"workbench/transaction/getContacts.do",
					data:{
						con:$("#contactSearchCondition").val(),
						name:$("#edit-contactsName").val()
					},
					dataType:"json",
					type:"GET",
					success:function (data) {
						$.each(data,function (index,ele) {
							html+='<tr>';
							html+='<td><input type="radio" name="contacts" value="'+ele.id+'"/></td>';
							html+='<td id="c'+ele.id+'">'+ele.fullname+'</td>';
							html+='<td>'+ele.email+'</td>';
							html+='<td>'+ele.mphone+'</td>';
							html+='</tr>';
						})
						$("#contactsBody").html(html);
					}
				})
				return false;
			}
		})

		$("#bundContactsBtn").click(function () {
			var obj=$("input[name=contacts]:checked").val();
			var fullname=$("#c"+obj).html();
			$("#edit-contactsName").val(fullname);
			$("#edit-contactId").val(obj);
			$("#findContacts").modal("hide");
		})
	})

	function showTransactionMsg(){
		$("#edit-owner option").remove();
		$.ajax({
			url:"workbench/activity/getUserList.do",
			dataType:"json",
			type:"GET",
			async:false,
			success:function (data) {
				$.each(data,function (index,ele) {
					$("#edit-owner").append(new Option(ele.name,ele.id));
					if("${t.owner}"==ele.name){
						$("#edit-owner").val(ele.id);
					}
				})

			}
		})
		$("#edit-stage").val("${t.stage}");
		$("#edit-type").val("${t.type}")
		$("#edit-source").val("${t.source}")


	}
</script>
<body>

	<!-- 查找市场活动 -->	
	<div class="modal fade" id="findMarketActivity" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="activitySearchCondition">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
							</tr>
						</thead>
						<tbody id="activitySearchBody">

							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="bundBtn">关联</button>
					</div>
				</div>
			</div>
		</div>
	</div>

	<!-- 查找联系人 -->	
	<div class="modal fade" id="findContacts" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">查找联系人</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入联系人名称，支持模糊查询" id="contactSearchCondition">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td></td>
								<td>名称</td>
								<td>邮箱</td>
								<td>手机</td>
							</tr>
						</thead>
						<tbody id="contactsBody">
<%--							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>
							<tr>
								<td><input type="radio" name="activity"/></td>
								<td>李四</td>
								<td>lisi@bjpowernode.com</td>
								<td>12345678901</td>
							</tr>--%>
						</tbody>
					</table>
					<div class="modal-footer">
						<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
						<button type="button" class="btn btn-primary" id="bundContactsBtn">关联</button>
					</div>
				</div>
			</div>
		</div>
	</div>
	
	
	<div style="position:  relative; left: 30px;">
		<h3>更新交易</h3>
	  	<div style="position: relative; top: -40px; left: 70%;">
			<button type="button" class="btn btn-primary" id="update">更新</button>
			<button type="button" class="btn btn-default" id="cancelBtn">取消</button>
		</div>
		<hr style="position: relative; top: -40px;">
	</div>
	<form class="form-horizontal" role="form" style="position: relative; top: -30px;">
		<div class="form-group">
			<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-owner">

				</select>
			</div>
			<label for="edit-money" class="col-sm-2 control-label">金额</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-money" value="${t.money}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-name" class="col-sm-2 control-label">名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-name" value="${t.name}">
			</div>
			<label for="edit-expectedDate" class="col-sm-2 control-label">预计成交日期<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time1" id="edit-expectedDate" value="${t.expectedDate}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-customerName" class="col-sm-2 control-label">客户名称<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-customerName" value="${t.customerName}" placeholder="支持自动补全，输入客户不存在则新建">
			</div>
			<label for="edit-stage" class="col-sm-2 control-label">阶段<span style="font-size: 15px; color: red;">*</span></label>
			<div class="col-sm-10" style="width: 300px;">
			  <select class="form-control" id="edit-stage">
			  	<option></option>
				  <c:forEach items="${applicationScope.stageList}" var="s">
					  <option value="${s.value}">${s.text}</option>
				  </c:forEach>
			  </select>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-type" class="col-sm-2 control-label">类型</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-type">
				  <option></option>
					<c:forEach items="${applicationScope.transactionTypeList}" var="type">
						<option value="${type.value}">${type.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-possibility" class="col-sm-2 control-label">可能性</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-possibility" value="${t.possibility}" disabled>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-source" class="col-sm-2 control-label">来源</label>
			<div class="col-sm-10" style="width: 300px;">
				<select class="form-control" id="edit-source">
				  <option></option>
					<c:forEach items="${applicationScope.sourceList}" var="s">
						<option value="${s.value}">${s.text}</option>
					</c:forEach>
				</select>
			</div>
			<label for="edit-activityName" class="col-sm-2 control-label">市场活动源&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" id="findActivityBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-activityName" value="${t.activityName}" disabled>
				<input type="hidden" id="edit-activityId" value="${t.activityId}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactsName" class="col-sm-2 control-label">联系人名称&nbsp;&nbsp;<a href="javascript:void(0);" data-toggle="modal" id="openContactsBtn"><span class="glyphicon glyphicon-search"></span></a></label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control" id="edit-contactsName" value="${t.contactsName}" disabled>
				<input type="hidden" id="edit-contactId" value="${t.contactsId}">
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-description" class="col-sm-2 control-label">描述</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-description">${t.description}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
			<div class="col-sm-10" style="width: 70%;">
				<textarea class="form-control" rows="3" id="edit-contactSummary">${t.contactSummary}</textarea>
			</div>
		</div>
		
		<div class="form-group">
			<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
			<div class="col-sm-10" style="width: 300px;">
				<input type="text" class="form-control time" id="edit-nextContactTime" value="${t.nextContactTime}">
			</div>
		</div>
		
	</form>
</body>
</html>