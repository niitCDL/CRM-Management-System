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

<script type="text/javascript">

	//默认情况下取消和保存按钮是隐藏的
	var cancelAndSaveBtnDefault = true;
	
	$(function(){
		$("#remark").focus(function(){
			if(cancelAndSaveBtnDefault){
				//设置remarkDiv的高度为130px
				$("#remarkDiv").css("height","130px");
				//显示
				$("#cancelAndSaveBtn").show("2000");
				cancelAndSaveBtnDefault = false;
			}
		});
		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
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
		
		$(".remarkDiv").mouseover(function(){
			$(this).children("div").children("div").show();
		});
		
		$(".remarkDiv").mouseout(function(){
			$(this).children("div").children("div").hide();
		});
		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});

		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})

		$("#activityNotRelationBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})

		showremarkList();
		showTranList();
		showActivityList();
		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/contact/saveRemark.do",
				data:{
					contactsId:"${con.id}",
					noteContent:$("#remark").val()
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						$("#remark").val("")
						showremarkList();
					}else {
						alert("添加联系人备注失败!");
					}
				}
			})
		})

		$("#updateRemarkBtn").click(function () {
			var id=$("#remarkId").val();
			$.ajax({
				url:"workbench/contact/updateRemark.do",
				data:{
					id:id,
					noteContent:$("#noteContent").val()
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						showremarkList();
						$("#editRemarkModal").modal("hide");
					}else {
						alert("修改联系人备注失败!");
					}
				}
			})
		})

		$("#delTranBtn").click(function () {
			$.ajax({
				url:"workbench/contact/delTranBtn.do",
				data:{
					tid:$("#hidden-tid").val(),
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						$("#removeTransactionModal").modal("hide");
						showTranList();
					}else {
						alert("删除交易失败!");
					}
				}
			})
		})

		$("#openBundModal").click(function () {
			$("#activitySearchBody").val("")
			$("#activityNotRelationBody").html("")
			$("#bundActivityModal").modal("show")
		})

		$("#activitySearchBody").keydown(function (event) {
			if(event.keyCode=="13"){
				var html="";
				$.ajax({
					url:"workbench/contact/getActivityListByNameNotByConId.do",
					type: "GET",
					data: {
						conid:"${con.id}",
						aname:$.trim($("#activitySearchBody").val())
					},
					dataType:"json",
					success:function (data) {
						$.each(data,function (index,ele) {
							html +='<tr>';
							html +='<td><input type="checkbox" value="'+ele.id+'" name="xz"/></td>';
							html +='<td>'+ele.name+'</td>';
							html +='<td>'+ele.startDate+'</td>';
							html +='<td>'+ele.endDate+'</td>';
							html +='<td>'+ele.owner+'</td>';
							html +='</tr>';
						})
						$("#activityNotRelationBody").html(html);
					}
				})
				return false;
			}
		})


		$("#bundBtn").click(function () {
			var $xz=$("input[name=xz]:checked")
			var param="conid=${con.id}&";
			$.each($xz,function (index,ele) {
				param+="id="+ele.value;
				if(index<$xz.length-1){
					param+="&";
				}
			})
			$.ajax({
				url:"workbench/contact/bund.do",
				data:param,
				dataType:"json",
				type:"GET",
				success:function (data) {
					if(data.success){
						$("#qx").attr("checked",false);
						showActivityList();
						$("#bundActivityModal").modal("hide");
					}else {
						alert("关联失败")
					}
				}
			})
		})

		$("#editBtn").click(function () {
			$("#edit-owner option").remove();
			$.ajax({
				url:"workbench/activity/getUserList.do",
				dataType:"json",
				type:"GET",
				success:function (data) {
					$.each(data,function (index,ele) {
						$("#edit-owner").append(new Option(ele.name,ele.id));
						if("${con.owner}"==ele.name){
							$("#edit-owner").val(ele.id);
						}
					})
				}
			})
			$("#edit-source").val("${con.source}");
			$("#edit-customerName").val("${con.customerName}");
			$("#edit-fullname").val("${con.fullname}");
			$("#edit-appellation").val("${con.appellation}");
			$("#edit-email").val("${con.email}");
			$("#edit-mphone").val("${con.mphone}");
			$("#edit-job").val("${con.job}");
			$("#edit-birth").val("${con.birth}");
			$("#edit-description").val("${con.description}");
			$("#edit-contactSummary").val("${con.contactSummary}");
			$("#edit-nextContactTime").val("${con.nextContactTime}");
			$("#edit-address").val("${con.address}");
			$("#editContactsModal").modal("show");
		})

		$("#updateBtn").click(function () {
			var owner=$("#edit-owner").val();
			var fullname=$("#edit-fullname").val();
			var customerName=$("#edit-customerName").val();
			if(owner==null||owner==''){
				alert("所有者不能为空!");
				return;
			}
			if(fullname==null||fullname==''){
				alert("联系人名称不能为空!");
				return;
			}
			if(customerName==null||customerName==''){
				alert("客户名称不能为空!");
				return;
			}
			$.ajax({
				url:"workbench/contact/update.do",
				type:"POST",
				data:{
					id:"${con.id}",
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
				success:function (data) {
					if(data.success){
						$("#editContactsModal").modal("hide");
						window.location.href="workbench/contact/detail.do?id=${con.id}";
					}else {
						alert("修改失败");
					}
				}
			})

		})

		$("#deleteContactBtn").click(function () {
			if(confirm("确定要删除该联系人吗")){
				$.ajax({
					url: "workbench/contact/delete.do",
					data:{id:"${con.id}"},
					type:"POST",
					dataType: "json",
					success:function (data) {
						if(data.success){
							window.location.href="workbench/contacts/index.jsp";
						}else {
							alert("删除联系人失败!");
						}
					}
				})
			}
		})



	});

	function showremarkList(){
		var html="";
		$.ajax({
			url:"workbench/contact/getRemark.do",
			data:{
				id:"${con.id}"
			},
			dataType:"json",
			type:"GET",
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<div class="remarkDiv" style="height: 60px;">'
					html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
					html+='<div style="position: relative; top: -40px; left: 40px;" >'
					html+='<h5 id="e'+ele.id+'">'+ele.noteContent+'</h5>'
					html+='<font color="gray">联系人</font> <font color="gray">-</font> <b>${con.fullname}-${con.customerName}</b> <small style="color: gray;"> '+(ele.editFlag==1?ele.editTime:ele.createTime)+'由'+(ele.editFlag==1?ele.editBy:ele.createBy)+'</small>'
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
					html+='<a class="myHref" href="javascript:void(0);" onclick=editRemark(\''+ele.id+'\')><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref" href="javascript:void(0);" onclick=deleteRemark(\''+ele.id+'\')><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:red;"></span></a>';
					html+='</div>'
					html+='</div>'
					html+='</div>'
				})
				$("#remarkList").html(html);
			}
		})
	}

	function deleteRemark(id) {
		if (confirm("是否删除当条记录?")){
			$.ajax({
				url:"workbench/contact/deleteRemark.do",
				data:{
					id:id
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						showremarkList();
					}else {
						alert("删除联系人备注失败!");
					}
				}
			})
		}
	}

	function editRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).html());
		$("#editRemarkModal").modal("show")
	}

	function showTranList(){
		var html="";
		$.ajax({
			url:"workbench/contact/getTranByConid.do",
			data:{
				conid:"${con.id}"
			},
			dataType:"json",
			type:"GET",
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<tr>'
					html+='<td><a href="workbench/transaction/detail.do?id='+ele.id+'" style="text-decoration: none;">${con.fullname}-'+ele.name+'</a></td>'
					html+='<td>'+(ele.money==""?"null":ele.money)+'</td>'
					html+='<td>'+ele.stage+'</td>'
					html+='<td>'+ele.possibility+'</td>'
					html+='<td>'+ele.expectedDate+'</td>'
					html+='<td>'+(ele.type==""?"null":ele.type)+'</td>'
					html+='<td><a href="javascript:void(0);" onclick="opendelTran(\''+ele.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
					html+='</tr>'
				})
				console.log(data)
				$("#TranBody").html(html);
			}
		})
	}

	function opendelTran(id){
		$("#hidden-tid").val(id);
		$("#removeTransactionModal").modal("show");
	}

	function unbund(id) {
		if(confirm("确定要解除关联?")){
			$.ajax({
				url:"workbench/contact/deleteByRelationId.do",
				type: "POST",
				data: {
					id:id
				},
				dataType: "json",
				success:function (data) {
					if(data.success){
						showActivityList();
					}else {
						alert("解除关联失败");
					}
				}
			})
		}
	}

	function showActivityList(){
		var html="";
		$.ajax({
			url:"workbench/contact/getActivityList.do",
			type: "GET",
			data: {
				conid:"${con.id}"
			},
			dataType:"json",
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<tr>';
					html+='<td>'+ele.name+'</td>';
					html+='<td>'+ele.startDate+'</td>';
					html+='<td>'+ele.endDate+'</td>';
					html+='<td>'+ele.owner+'</td>';
					html+='<td><a href="javascript:void(0);"  onclick="unbund(\''+ele.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>';
					html+='</tr>';
				})
				$("#activityBody").html(html);
			}
		})
	}


</script>

</head>
<body>

	<input type="hidden" id="hidden-tid">
	<%--删除交易的模态窗口--%>
	<div class="modal fade" id="removeTransactionModal" role="dialog">
		<input type="hidden" id="hidden-tid">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除交易</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该交易吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="delTranBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 修改市场活动备注的模态窗口 -->
	<div class="modal fade" id="editRemarkModal" role="dialog">
		<%-- 备注的id --%>
		<input type="hidden" id="remarkId">
		<div class="modal-dialog" role="document" style="width: 40%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel">修改备注</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
						<div class="form-group">
							<label for="edit-describe" class="col-sm-2 control-label">内容</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="noteContent"></textarea>
							</div>
						</div>
					</form>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="updateRemarkBtn">更新</button>
				</div>
			</div>
		</div>
	</div>
	<!-- 解除联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="unbundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">解除关联</h4>
				</div>
				<div class="modal-body">
					<p>您确定要解除该关联关系吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" data-dismiss="modal">解除</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 联系人和市场活动关联的模态窗口 -->
	<div class="modal fade" id="bundActivityModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 80%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">关联市场活动</h4>
				</div>
				<div class="modal-body">
					<div class="btn-group" style="position: relative; top: 18%; left: 8px;">
						<form class="form-inline" role="form">
						  <div class="form-group has-feedback">
						    <input type="text" class="form-control" style="width: 300px;" placeholder="请输入市场活动名称，支持模糊查询" id="activitySearchBody">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable2" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
						<thead>
							<tr style="color: #B3B3B3;">
								<td><input type="checkbox" id="qx"/></td>
								<td>名称</td>
								<td>开始日期</td>
								<td>结束日期</td>
								<td>所有者</td>
								<td></td>
							</tr>
						</thead>
						<tbody id="activityNotRelationBody">
							<%--<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>
							<tr>
								<td><input type="checkbox"/></td>
								<td>发传单</td>
								<td>2020-10-10</td>
								<td>2020-10-20</td>
								<td>zhangsan</td>
							</tr>--%>
						</tbody>
					</table>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-primary" id="bundBtn">关联</button>
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
					<h4 class="modal-title" id="myModalLabel">修改联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">
					
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
									  <option value="${s.text}">${s.value}</option>
								  </c:forEach>
								</select>
							</div>
						</div>
						
						<div class="form-group">
							<label for="edit-fullname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="edit-fullname" value="李四">
							</div>
							<label for="edit-appellation" class="col-sm-2 control-label">称呼</label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="edit-appellation">
								  <option></option>
									<c:forEach items="${applicationScope.appellationList}" var="s">
										<option value="${s.text}">${s.value}</option>
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
                                    <textarea class="form-control" rows="1" id="edit-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" data-dismiss="modal" id="updateBtn">更新</button>
				</div>
			</div>
		</div>
	</div>

	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${con.fullname} <small> - ${con.customerName}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" data-toggle="modal" id="editBtn"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteContactBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.source eq ""?"null":con.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.customerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">姓名</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.fullname eq ""?"null":con.fullname}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.email eq ""?"null":con.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.mphone eq ""?"null":con.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.job eq ""?"null":con.job}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">生日</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${con.birth eq ""?"null":con.birth}&nbsp;</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${con.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${con.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${con.editBy eq ""?"null":con.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${con.editTime eq ""?"null":con.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${con.description eq ""?"null":con.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${con.contactSummary eq ""?"null":con.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${con.nextContactTime eq ""?"null":con.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 90px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${con.address eq ""?"null":con.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	<!-- 备注 -->
	<div style="position: relative; top: 20px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkList"></div>

		
		<div id="remarkDiv" style="background-color: #E6E6E6; width: 870px; height: 90px;">
			<form role="form" style="position: relative;top: 10px; left: 10px;">
				<textarea id="remark" class="form-control" style="width: 850px; resize : none;" rows="2"  placeholder="添加备注..."></textarea>
				<p id="cancelAndSaveBtn" style="position: relative;left: 737px; top: 10px; display: none;">
					<button id="cancelBtn" type="button" class="btn btn-default">取消</button>
					<button type="button" class="btn btn-primary" id="saveRemarkBtn">保存</button>
				</p>
			</form>
		</div>
	</div>
	
	<!-- 交易 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable3" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>金额</td>
							<td>阶段</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>类型</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="TranBody">
						<%--<tr>
							<td><a href="transaction/detail.html" style="text-decoration: none;">动力节点-交易01</a></td>
							<td>5,000</td>
							<td>谈判/复审</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>新业务</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/contact/forwardTran.do?conid=${con.id}&conname=${con.fullname}" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>开始日期</td>
							<td>结束日期</td>
							<td>所有者</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="activityBody">
						<%--<tr>
							<td><a href="activity/detail.jsp" style="text-decoration: none;">发传单</a></td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);" data-toggle="modal" data-target="#unbundActivityModal" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" id="openBundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>