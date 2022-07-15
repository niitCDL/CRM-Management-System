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

		$("#remarkBody").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkBody").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})

		
		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
		});

		
		$(".myHref").mouseover(function(){
			$(this).children("span").css("color","red");
		});
		
		$(".myHref").mouseout(function(){
			$(this).children("span").css("color","#E6E6E6");
		});
		showremarkList();
		showTranList();
		showContactList();

		$("#updateRemarkBtn").click(function () {
			var id=$("#remarkId").val();
			$.ajax({
				url:"workbench/customer/updateRemark.do",
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
						alert("修改客户备注失败!");
					}
				}
			})
		})

		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/customer/saveRemark.do",
				data:{
					customerId:"${c.id}",
					noteContent:$("#remark").val()
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						$("#remark").val("")
						showremarkList();
					}else {
						alert("添加客户备注失败!");
					}
				}
			})
		})

		$("#delTranBtn").click(function () {
			$.ajax({
				url:"workbench/customer/delTranBtn.do",
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

		$("#delContactBtn").click(function () {
			var con_id=$("#hidden-conId").val();
			$.ajax({
				url:"workbench/customer/delContact.do",
				data:{
					conid:con_id,
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						$("#removeContactsModal").modal("hide");
						showContactList();
					}else {
						alert("删除交易失败!");
					}
				}
			})
		})

		$("#openCreateContact").click(function () {
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
			$("#create-customerName").val("${c.name}");
			$("#create-customerName").attr("disabled","disabled");
			$("#createContactsModal").modal("show")
		})

		$("#saveContactBtn").click(function () {
			var owner=$("#create-owner").val();
			var fullname=$("#create-fullname").val();
			if(owner==null||owner==''){
				alert("所有者不能为空");
				return;
			}
			if(fullname==null||fullname==''){
				alert("联系人名称不能为空");
				return;
			}
			$.ajax({
				url:"workbench/customer/saveContact.do",
				data:{
					owner:$("#create-owner").val(),
					source:$("#create-source").val(),
					customerId:"${c.id}",
					fullname:$("#create-fullname").val(),
					appellation:$("#create-appellation").val(),
					email:$("#create-email").val(),
					mphone:$("#create-mphone").val(),
					job:$("#create-job").val(),
					birth:$("#create-birth").val(),
					description:$("#create-description").val(),
					contactSummary:$("#create-contactSummary").val(),
					nextContactTime:$("#create-nextContactTime").val(),
					address:$("#create-address").val()
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						showContactList();
						$("#createContactsModal").modal("hide");
					}else {
						alert("添加联系人失败!");
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
						if("${c.owner}"==ele.name){
							$("#edit-owner").val(ele.id);
						}
					})
				}
			})

			$("#edit-name").val("${c.name}");
			$("#edit-website").val("${c.website}");
			$("#edit-phone").val("${c.phone}");
			$("#edit-description").val("${c.description}");
			$("#edit-contactSummary").val("${c.contactSummary}");
			$("#edit-nextContactTime").val("${c.nextContactTime}");
			$("#edit-address").val("${c.address}");
			$("#editCustomerModal").modal("show");
		})

		$("#delBtn").click(function () {
			if(confirm("确定要删除该联系人吗")){
				$.ajax({
					url: "workbench/customer/delete.do",
					data:{id:"${c.id}"},
					type:"POST",
					dataType: "json",
					success:function (data) {
						if(data.success){
							window.location.href="workbench/customer/index.jsp";
						}else {
							alert("删除客户失败!");
						}
					}
				})
			}
		})

		$("#updateBtn").click(function () {
			var owner=$("#edit-owner").val();
			var name=$("#edit-name").val();
			if(owner==null||owner==''){
				alert("所有者不能为空!");
				return;
			}
			if(name==null||name=='') {
				alert("客户名称不能为空!");
				return;
			}
			$.ajax({
				url:"workbench/customer/update.do",
				type:"POST",
				data:{
					id:"${c.id}",
					owner:$("#edit-owner").val(),
					name:$("#edit-name").val(),
					website:$("#edit-website").val(),
					phone:$("#edit-phone").val(),
					contactSummary:$("#edit-contactSummary").val(),
					nextContactTime:$("#edit-nextContactTime").val(),
					description:$("#edit-description").val(),
					address:$("#edit-address").val()
				},
				success:function (data) {
					if(data.success){
						$("#editCustomerModal").modal("hide");
						window.location.href="workbench/customer/detail.do?id=${c.id}";
					}else {
						alert("修改失败");
					}
				}
			})

		})


	});

	function showTranList(){
		var html="";
		$.ajax({
			url:"workbench/customer/getTranByCid.do",
			data:{
				cid:"${c.id}"
			},
			dataType:"json",
			type:"GET",
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<tr>'
					html+='<td><a href="workbench/transaction/detail.do?id='+ele.id+'" style="text-decoration: none;">${c.name}-'+ele.name+'</a></td>'
					html+='<td>'+(ele.money==""?"null":ele.money)+'</td>'
					html+='<td>'+ele.stage+'</td>'
					html+='<td>'+ele.possibility+'</td>'
					html+='<td>'+ele.expectedDate+'</td>'
					html+='<td>'+(ele.type==""?"null":ele.type)+'</td>'
					html+='<td><a href="javascript:void(0);" onclick="opendelTran(\''+ele.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
					html+='</tr>'
				})
				$("#TranBody").html(html);
			}
		})
	}

	function showContactList(){
		var html="";
		$.ajax({
			url:"workbench/customer/getContactByCid.do",
			data:{
				cid:"${c.id}"
			},
			dataType:"json",
			type:"GET",
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<tr>'
					html+='<td><a href="contacts/detail.html" style="text-decoration: none;">'+ele.fullname+'</a></td>'
					html+='<td>'+(ele.email==''?"null":ele.email)+'</td>'
					html+='<td>'+(ele.mphone==''?"null":ele.mphone)+'</td>'
					html+='<td><a href="javascript:void(0);" data-toggle="modal"  onclick="openRemoveContact(\''+ele.id+'\')" style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>删除</a></td>'
					html+='</tr>'
				})
				$("#contactBody").html(html);
			}
		})

	}

	function editRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).html());
		$("#editRemarkModal").modal("show")
	}

	function showremarkList(){
		var html="";
		$.ajax({
			url:"workbench/customer/getRemark.do",
			data:{
				id:"${c.id}"
			},
			dataType:"json",
			type:"GET",
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<div class="remarkDiv" style="height: 60px;">'
					html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
					html+='<div style="position: relative; top: -40px; left: 40px;" >'
					html+='<h5 id="e'+ele.id+'">'+ele.noteContent+'</h5>'
					html+='<font color="gray">联系人</font> <font color="gray">-</font> <b>${c.name}-${c.address}</b> <small style="color: gray;"> '+(ele.editFlag==1?ele.editTime:ele.createTime)+' 由'+(ele.editFlag==1?ele.editBy:ele.createBy)+'</small>'
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
					html+='<a class="myHref" href="javascript:void(0);" onclick=editRemark(\''+ele.id+'\')><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>';
					html+='&nbsp;&nbsp;&nbsp;&nbsp;';
					html+='<a class="myHref" href="javascript:void(0);" onclick=deleteRemark(\''+ele.id+'\')><span class="glyphicon glyphicon-remove" style="font-size: 20px; color:red;"></span></a>';
					html+='</div>';
					html+='</div>';
					html+='</div>';
				})
				$("#remarkList").html(html);
			}
		})
	}

	function deleteRemark(id) {
		if (confirm("是否删除当条记录?")){
			$.ajax({
				url:"workbench/customer/deleteRemark.do",
				data:{
					id:id
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						showremarkList();
					}else {
						alert("删除客户备注失败!");
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

	function opendelTran(id){
		$("#hidden-tid").val(id);
		$("#removeTransactionModal").modal("show");
	}

	function openRemoveContact(id) {
		$("#hidden-conId").val(id);
		$("#removeContactsModal").modal("show")
	}


	
</script>

</head>
<body>
<!-- 修改客户备注的模态窗口 -->
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
	<!-- 删除联系人的模态窗口 -->
	<div class="modal fade" id="removeContactsModal" role="dialog">
		<input type="hidden" id="hidden-conId">
		<div class="modal-dialog" role="document" style="width: 30%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" data-dismiss="modal">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title">删除联系人</h4>
				</div>
				<div class="modal-body">
					<p>您确定要删除该联系人吗？</p>
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">取消</button>
					<button type="button" class="btn btn-danger" id="delContactBtn">删除</button>
				</div>
			</div>
		</div>
	</div>

    <!-- 删除交易的模态窗口 -->
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
	
	<!-- 创建联系人的模态窗口 -->
	<div class="modal fade" id="createContactsModal" role="dialog">
		<div class="modal-dialog" role="document" style="width: 85%;">
			<div class="modal-content">
				<div class="modal-header">
					<button type="button" class="close" onclick="$('#createContactsModal').modal('hide');">
						<span aria-hidden="true">×</span>
					</button>
					<h4 class="modal-title" id="myModalLabel1">创建联系人</h4>
				</div>
				<div class="modal-body">
					<form class="form-horizontal" role="form">

						<div class="form-group">
							<label for="create-contactsOwner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<select class="form-control" id="create-owner">
								  <option>zhangsan</option>
								  <option>lisi</option>
								  <option>wangwu</option>
								</select>
							</div>
							<label for="create-clueSource" class="col-sm-2 control-label">来源</label>
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
							<label for="create-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
							<div class="col-sm-10" style="width: 300px;">
								<input type="text" class="form-control" id="create-fullname">
							</div>
							<label for="create-call" class="col-sm-2 control-label">称呼</label>
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
								<input type="text" class="form-control" id="create-customerName">
							</div>
						</div>
						
						<div class="form-group" style="position: relative;">
							<label for="create-describe" class="col-sm-2 control-label">描述</label>
							<div class="col-sm-10" style="width: 81%;">
								<textarea class="form-control" rows="3" id="create-description"></textarea>
							</div>
						</div>
						
						<div style="height: 1px; width: 103%; background-color: #D5D5D5; left: -13px; position: relative;"></div>

                        <div style="position: relative;top: 15px;">
                            <div class="form-group">
                                <label for="edit-contactSummary" class="col-sm-2 control-label">联系纪要</label>
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
                                <label for="edit-address1" class="col-sm-2 control-label">详细地址</label>
                                <div class="col-sm-10" style="width: 81%;">
                                    <textarea class="form-control" rows="1" id="create-address"></textarea>
                                </div>
                            </div>
                        </div>
					</form>
					
				</div>
				<div class="modal-footer">
					<button type="button" class="btn btn-default" data-dismiss="modal">关闭</button>
					<button type="button" class="btn btn-primary" id="saveContactBtn">保存</button>
				</div>
			</div>
		</div>
	</div>
	
	<!-- 修改客户的模态窗口 -->
    <div class="modal fade" id="editCustomerModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 85%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改客户</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">

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
                            <label for="edit-website" class="col-sm-2 control-label">公司网站</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-website">
                            </div>
                            <label for="edit-phone" class="col-sm-2 control-label">公司座机</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <input type="text" class="form-control" id="edit-phone">
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
                                <label for="create-nextContactTime2" class="col-sm-2 control-label">下次联系时间</label>
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
                                    <textarea class="form-control" rows="1" id="edit-address">北京大兴大族企业湾</textarea>
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
			<h3>${c.name} <small><a href="http://www.baidu.com" target="_blank">${c.website}</a></small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" id="editBtn"><span class="glyphicon glyphicon-edit" ></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus" ></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.name}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.website eq ""?"&nbsp;":c.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.phone eq ""?"&nbsp;":c.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy eq ""?"&nbsp;":c.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.editTime eq ""?"&nbsp;":c.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 40px;">
            <div style="width: 300px; color: gray;">联系纪要</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
                    ${c.contactSummary eq ""?"&nbsp;":c.contactSummary}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
        <div style="position: relative; left: 40px; height: 30px; top: 50px;">
            <div style="width: 300px; color: gray;">下次联系时间</div>
            <div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.nextContactTime eq ""?"&nbsp;":c.nextContactTime}</b></div>
            <div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
        </div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${c.description eq ""?"&nbsp;":c.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 70px;">
            <div style="width: 300px; color: gray;">详细地址</div>
            <div style="width: 630px;position: relative; left: 200px; top: -20px;">
                <b>
					${c.address eq ""?"&nbsp;":c.address}
                </b>
            </div>
            <div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
        </div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 10px; left: 40px;" id="remarkBody">
		<div class="page-header">
			<h4>备注</h4>
		</div>

		<div id="remarkList">

		</div>
		
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
		<div style="position: relative; top: 20px; left: 40px;" >
			<div class="page-header">
				<h4>交易</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable2" class="table table-hover" style="width: 900px;">
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

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="workbench/customer/forwardTransave.do?cname=${c.name}&cid=${c.id}" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建交易</a>
			</div>
		</div>
	</div>
	
	<!-- 联系人 -->
	<div>
		<div style="position: relative; top: 20px; left: 40px;">
			<div class="page-header">
				<h4>联系人</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>名称</td>
							<td>邮箱</td>
							<td>手机</td>
							<td></td>
						</tr>
					</thead>
					<tbody id="contactBody">

					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" data-toggle="modal" id="openCreateContact" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>新建联系人</a>
			</div>
		</div>
	</div>
	
	<div style="height: 200px;"></div>
</body>
</html>