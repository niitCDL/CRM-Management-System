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
<link rel="stylesheet" type="text/css" href="jquery/bs_pagination/jquery.bs_pagination.min.css">

<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/js/bootstrap-datetimepicker.js"></script>
<script type="text/javascript" src="jquery/bootstrap-datetimepicker-master/locale/bootstrap-datetimepicker.zh-CN.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/en.js"></script>
<script type="text/javascript" src="jquery/bs_pagination/jquery.bs_pagination.min.js"></script>
<script type="text/javascript" src="jquery/bs_typeahead/bootstrap3-typeahead.min.js"></script>

<script type="text/javascript">

	$(function(){
		
		//定制字段
		$("#definedColumns > li").click(function(e) {
			//防止下拉菜单消失
	        e.stopPropagation();
	    });

		$("#create-customerName").typeahead({
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

		$(".time").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "bottom-left"
		});

		$(".time1").datetimepicker({
			minView: "month",
			language:  'zh-CN',
			format: 'yyyy-mm-dd',
			autoclose: true,
			todayBtn: true,
			pickerPosition: "top-left"
		});

		pageList(1,2);

		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})

		$("#contactBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})

		$("#searchBtn").click(function () {
			$("#hidden-fullname").val($.trim($("#search-fullname").val()));
			$("#hidden-owner").val($.trim($("#search-owner").val()));
			$("#hidden-customerName").val($.trim($("#search-customerName").val()));
			$("#hidden-source").val($.trim($("#search-source").val()));
			$("#hidden-birth").val($.trim($("#search-birth").val()));
			pageList(1,2);
		})

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
			$("#createContactsModal").modal("show");
		})

		$("#saveBtn").click(function () {
			var owner=$.trim($("#create-owner").val());
			var fullname=$.trim($("#create-fullname").val());
			var customerName=$.trim($("#create-customerName").val());
			if(owner==null||owner==""){
				alert("所有者不能为空");
				return;
			}
			if(fullname==null||fullname==""){
				alert("联系人名称不能为空");
				return;
			}
			if(customerName==null||customerName==""){
				alert("客户名称不能为空");
				return;
			}
			$.ajax({
				url: "workbench/contact/save.do",
				data:{
					owner:$("#create-owner").val(),
					source:$("#create-source").val(),
					customerName:$("#create-customerName").val(),
					fullname:$("#create-fullname").val(),
					appellation:$("#create-appellation").val(),
					email:$("#create-email").val(),
					mphone:$("#create-mphone").val(),
					job:$("#create-job").val(),
					birth:$("#create-birth").val(),
					description:$("#create-description").val(),
					contactSummary:$("#create-contactSummary").val(),
					nextContactTime:$("#create-nextContactTime").val(),
					address:$("#create-address").val(),
				},
				dataType: "json",
				success:function (data) {
					if(data.success){
						pageList(1,$("#contactPage").bs_pagination('getOption', 'rowsPerPage'));
						$("#addContactForm")[0].reset();
						$("#createContactsModal").modal("hide");
					}else {
						alert("添加联系人失败!");
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
					url: "workbench/contact/getUserListandContact.do",
					data:{
						"id":id
					},
					dataType: "json",
					success:function (data) {
						$("#edit-owner")[0].length=0;
						$.each(data.userList,function (index,ele) {
							$("#edit-owner").append(new Option(ele.name,ele.id));
							if(data.contact.owner==ele.name){
								$("#edit-owner").val(ele.id);
							}
						})
						var c=data.contact;
						$("#edit-source").val(c.source),
						$("#edit-customerName").val(c.customerName),
						$("#edit-fullname").val(c.fullname),
						$("#edit-appellation").val(c.appellation),
						$("#edit-email").val(c.email),
						$("#edit-mphone").val(c.mphone),
						$("#edit-job").val(c.job),
						$("#edit-birth").val(c.birth),
						$("#edit-description").val(c.description),
						$("#edit-contactSummary").val(c.contactSummary),
						$("#edit-nextContactTime").val(c.nextContactTime),
						$("#edit-address").val(c.address),
						$("#edit-id").val(c.id)
					}
				})
				$("#editContactsModal").modal("show");
			}
		})

		$("#updateBtn").click(function () {
			var fullname=$("#edit-fullname").val();
			var customerName=$.trim($("#create-customerName").val());
			if(fullname==null||fullname==""){
				alert("联系人名称不能为空");
				return;
			}
			if(customerName==null||customerName==""){
				alert("客户名称不能为空");
				return;
			}
			if(confirm("确定需要修改记录?")){
				$.ajax({
					url: "workbench/contact/update.do",
					data:{
						id:$("#edit-id").val(),
						owner:$("#edit-owner").val(),
						source:$("#edit-source").val(),
						customerName:$("#edit-customerName").val(),
						fullname:$("#edit-fullname").val(),
						appellation:$("#edit-appellation").val(),
						email:$("#edit-email").val(),
						mphone:$("#edit-mphone").val(),
						job:$("#edit-job").val(),
						birth:$("#edit-birth").val(),
						description:$("#edit-description").val(),
						contactSummary:$("#edit-contactSummary").val(),
						nextContactTime:$("#edit-nextContactTime").val(),
						address:$("#edit-address").val()
					},
					dataType: "json",
					type:"post",
					success:function (data) {
						if(data.success){
							pageList($("#contactPage").bs_pagination('getOption', 'currentPage')
									,$("#contactPage").bs_pagination('getOption', 'rowsPerPage'));
							$("#editContactsModal").modal("hide");
						}else {
							alert("修改联系人失败!");
						}
					}
				})
			}
		})

		$("#delBtn").click(function () {
			var param="";
			var $xz=$("input[name=xz]:checked");
			if($xz.length==0){
				alert("请选择你要删除的记录")
			}else {
				if(confirm("确定要删除这些记录吗?")){
					$.each($xz,function (index,ele) {
						param+="id="+ele.value+"&";
					})
					param=param.substring(0,param.length-1);
					$.ajax({
						url: "workbench/contact/delete.do",
						data:param,
						type:"POST",
						dataType: "json",
						success:function (data) {
							if(data.success){
								pageList(1,$("#contactPage").bs_pagination('getOption', 'rowsPerPage'));
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
		$("#search-fullname").val($.trim($("#hidden-fullname").val()));
		$("#search-customerName").val($.trim($("#hidden-customerName").val()));
		$("#search-owner").val($.trim($("#hidden-owner").val()));
		$("#search-source").val($.trim($("#hidden-source").val()));
		$("#search-birth").val($.trim($("#hidden-birth").val()));

		var html="";
		$.ajax({
			url:"workbench/contact/pageList.do",
			type: "GET",
			data: {
				pageNo:pageNo,
				pageSize:pageSize,
				owner:$("#search-owner").val(),
				fullname:$("#search-fullname").val(),
				customerName:$("#search-customerName").val(),
				source:$("#search-source").val(),
				birth:$("#search-birth").val()
			},
			dataType:"json",
			success:function (data) {
				$.each(data.activities,function (index,ele) {
					html+='<tr class="active" style="background-color: #f5f5f5">'
					html+='<td><input type="checkbox" name="xz" value="'+ele.id+'"/></td>'
					html+='<td><a style="text-decoration: none; cursor: pointer;" onclick="window.location.href=\'workbench/contact/detail.do?id='+ele.id+'\';">'+ele.fullname+'</a></td>'
					html+='<td>'+ele.customerName+'</td>'
					html+='<td>'+ele.owner+'</td>'
					html+='<td>'+ele.source+'</td>'
					/*html+='<td>'+ele.birth+'</td>'*/
					html+='</tr>'
				})
				$("#contactBody").html(html);
				var totalPages=data.total%pageSize==0?data.total/pageSize:parseInt(data.total/pageSize)+1;
				$("#contactPage").bs_pagination({
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
	<input type="hidden" id="hidden-fullname">
	<input type="hidden" id="hidden-customerName">
	<input type="hidden" id="hidden-source">
	<input type="hidden" id="hidden-birth">

	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabelx">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form" id="addContactForm">
					
						<div class="form-group">
							<label for="create-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="create-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-source">
								  <option></option>
								  <c:forEach items="${applicationScope.sourceList}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="create-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellationList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
							
						</div>
						
						<div class="form-group">
							<label for="create-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-job">
							</div>
							<label for="create-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-mphone">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-email">
							</div>
							<label for="create-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="create-birth">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-customerName" placeholder="支持自动补全，输入客户不存在则新建">
								<input type="hidden" id="create-customerId">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-description" class="col-sm-2 control-label">描述</label>
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
									<input type="text" class="form-control time1" id="create-nextContactTime">
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
	
	<!-- 修改联系人的模态窗口 -->
	<div class="modal fade" id="editContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<input id="edit-id" type="hidden">
						<div class="form-group">
							<label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-owner">

								</select>
							</div>
							<label for="edit-source" class="col-sm-2 control-label">来源</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-source">
								  <option></option>
									<c:forEach items="${applicationScope.sourceList}" var="s">
										<option value="${s.value}">${s.text}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
								  <c:forEach items="${applicationScope.appellationList}" var="s">
									  <option value="${s.value}">${s.text}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-job" class="col-sm-2 control-label">职位</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-job">
							</div>
							<label for="edit-mphone" class="col-sm-2 control-label">手机</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-mphone">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-email" class="col-sm-2 control-label">邮箱</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-email">
							</div>
							<label for="edit-birth" class="col-sm-2 control-label">生日</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control time" id="edit-birth">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-customerName" class="col-sm-2 control-label">客户名称</label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-customerName" placeholder="支持自动补全，输入客户不存在则新建">
								<input type="hidden" id="edit-customerId">
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-description" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="edit-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>
						
						<div style="position: relative;top: 15px;">
							<div class="form-group">
								<label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
								<div class="col-sm-10" style="width: 81%;">
									<textarea class="form-control" rows="3" id="edit-contactSummary"></textarea>
								</div>
							</div>
							<div class="form-group">
								<label for="edit-nextContactTime" class="col-sm-2 control-label">下次联系时间</label>
								<div class="col-sm-10" style="width: 300px;">
									<input type="text" class="form-control time1" id="edit-nextContactTime">
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
				<h3>联系人列表</h3>
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
				      <div class="input-group-addon">姓名</div>
				      <input class="form-control" type="text" id="search-fullname">
				    </div>
				  </div>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">客户名称</div>
				      <input class="form-control" type="text" id="search-customerName">
				    </div>
				  </div>
				  
				  <%--<br>--%>
				  
				  <div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">来源</div>
				      <select class="form-control" id="search-source">
						  <option></option>
						  <c:forEach items="${applicationScope.sourceList}" var="s">
							  <option value="${s.value}">${s.text}</option>
						  </c:forEach>
						</select>
				    </div>
				  </div>
				  
				  <%--<div class="form-group">
				    <div class="input-group">
				      <div class="input-group-addon">生日</div>
				      <input class="form-control time" type="text" id="search-birth">
				    </div>
				  </div>--%>
				  
				  <button type="button" class="btn btn-default" id="searchBtn">查询</button>
				  
				</form>
			</div>
			<div class="btn-toolbar" role="toolbar" style="background-color: #F7F7F7; height: 50px; position: relative;top: 10px;">
				<div class="btn-group" style="position: relative; top: 18%;">
				  <button type="button" class="btn btn-primary" data-toggle="modal" id="addBtn"><span class="glyphicon glyphicon-plus"></span> 创建</button>
				  <button type="button" class="btn btn-default" data-toggle="modal" id="editBtn"><span class="glyphicon glyphicon-pencil"></span> 修改</button>
				  <button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
				</div>
				
				
			</div>
			<div style="position: relative;top: 20px;">
				<table class="table table-hover">
					<thead>
						<tr style="color: #B3B3B3;">
							<td><input type="checkbox" id="qx"/></td>
							<td>姓名</td>
							<td>客户名称</td>
							<td>所有者</td>
							<td>来源</td>
							<%--<td>生日</td>--%>
						</tr>
					</thead>
					<tbody id="contactBody">

					</tbody>
				</table>
			</div>
			
			<div style="height: 50px; position: relative;top: 10px;">
				<div id="contactPage"></div>
			</div>
			
		</div>
		
	</div>
</body>
</html>