<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
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
		pageList(1,2);

		$("#queryTransactionBtn").click(function () {
			$("#hidden-owner").val($("#search-owner").val());
			$("#hidden-name").val($("#search-name").val());
			$("#hidden-customerName").val($("#search-customerName").val());
			$("#hidden-stage").val($("#search-state").val());
			$("#hidden-type").val($("#search-transactionType").val());
			$("#hidden-source").val($("#search-source").val());
			$("#hidden-contactName").val($("#search-contactName").val());
			pageList(1,$("#transactionPage").bs_pagination('getOption','rowsPerPage'));
		})

		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})

		$("#transactionBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})

		$("#deleteTranBtn").click(function () {
			var param="";
			var $xz=$("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择你要删除的记录")
			}else {
				if(confirm("确定要删除所选的记录吗?")){
					$.each($xz,function (index,ele) {
						param+="id="+ele.value;
						if(index<$xz.length-1){
							param+='&';
						}
					})
					$.ajax({
						url: "workbench/transaction/deleteTran.do",
						data:param,
						type:"POST",
						dataType: "json",
						success:function (data) {
							if(data.success){
								$("#qx").attr("checked",false);
								pageList(1,$("#transactionPage").bs_pagination('getOption', 'rowsPerPage'));
							}else {
								alert("删除交易失败!");
							}
						}
					})
				}
			}
		})

		$("#updateTranBtn").click(function () {
			var $xz=$("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选中修改的记录")
			}else if($xz.length>1){
				alert("只可以选择一条修改的记录")
			}else {
				window.location.href="workbench/transaction/edit.do?id="+$xz.val();
			}
		})


		
	});

	function pageList(pageNo,pageSize){
		$("#search-owner").val($("#hidden-owner").val());
		$("#search-name").val($("#hidden-name").val());
		$("#search-customerName").val($("#hidden-customerName").val());
		$("#search-state").val($("#hidden-state").val());
		$("#search-transactionType").val($("#hidden-type").val());
		$("#search-source").val($("#hidden-source").val());
		$("#search-contactName").val($("#hidden-contactName").val());
		var html="";
		$.ajax({
			url:"workbench/transaction/pageList.do",
			type: "GET",
			data: {
				pageNo:pageNo,
				pageSize:pageSize,
				owner:$("#search-owner").val(),
				name:$("#search-name").val(),
				customerId:$("#search-customerName").val(),
				stage:$("#search-stage").val(),
				type:$("#search-transactionType").val(),
				source:$("#search-source").val(),
				contactsId:$("#search-contactName").val()
			},
			dataType:"json",
			success:function (data) {
				$.each(data.activities,function (index,ele) {
					html+='<tr class="active">'
					html+='<td><input type="checkbox" name="xz" value='+ele.id+' /></td>'
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/transaction/detail.do?id='+ele.id+'\';">'+ele.name+'</a></td>'
					html+='<td>'+ele.customerId+'</td>'
					html+='<td>'+ele.stage+'</td>'
					html+='<td>'+ele.type+'</td>'
					html+='<td>'+ele.owner+'</td>'
					html+='<td>'+ele.source+'</td>'
					html+='<td>'+ele.contactsId+'</td>'
					html+='</tr>'
				})
				$("#transactionBody").html(html);
				var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;

				$("#transactionPage").bs_pagination({
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

	<input type="hidden" id="hidden-owner">
	<input type="hidden" id="hidden-name">
	<input type="hidden" id="hidden-customerName">
	<input type="hidden" id="hidden-stage">
	<input type="hidden" id="hidden-type">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-contactName">

	<div>
		<div style="position: relative; left: 10px; top: -10px;">
			<div class="page-header">
				<h3>交易列表</h3>
			</div>
		</div>
	</div>
	
	<div style="position: relative; top: -20px; left: 0px; width: 100%; height: 100%;">
	
		<div style="width: 100%; position: absolute;top: 5px; left: 10px;">
		
			<div class="btn-toolbar" role="toolbar" style="height: 80px;">
				<form class="form-inline" role="form" style="position: relative;top: 8%; left: 5px;">
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">所有者</div>
				      <input class="form-control" type="text" id="search-owner">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">名称</div>
				      <input class="form-control" type="text" id="search-name">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <br>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">阶段</div>
					  <select class="form-control" id="search-stage">
					  	<option></option>
						  <c:forEach items="${applicationScope.stageList}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">类型</div>
					  <select class="form-control" id="search-transactionType">
					  	<option></option>
						  <c:forEach items="${applicationScope.transactionTypeList}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
					  </select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${applicationScope.sourceList}" var="a">
							  <option value="${a.value}">${a.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">联系人名称</div>
				      <input class="form-control" type="text" id="search-contactName">
				    </div>
				  </div>
				  
				  <button type="button" class="btn btn-default" id="queryTransactionBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" onclick="window.location.href='workbench/transaction/save.jsp';"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" id="updateTranBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="deleteTranBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 10px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>名称</td>
							<td>客户名称</td>
							<td>阶段</td>
							<td>类型</td>
							<td>所有者</td>
							<td>来源</td>
							<td>联系人名称</td>
						</tr>
					</thead>
					<tbody id="transactionBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 20px;">
				<div id="transactionPage">

				</div>
			</div>
			
		</div>
		
	</div>
</body>
</html>