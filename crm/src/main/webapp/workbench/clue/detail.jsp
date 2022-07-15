<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
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
			pickerPosition: "top-left"
		});

		$("#remarkList").on("mouseover",".remarkDiv",function(){
			$(this).children("div").children("div").show();
		})
		$("#remarkList").on("mouseout",".remarkDiv",function(){
			$(this).children("div").children("div").hide();
		})


		$("#cancelBtn").click(function(){
			//显示
			$("#cancelAndSaveBtn").hide();
			//设置remarkDiv的高度为130px
			$("#remarkDiv").css("height","90px");
			cancelAndSaveBtnDefault = true;
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

		showActivityList();

		$("#relationBtn").click(function () {
			$("#bundModal").modal("show");
		})


		
		$("#activitySearchBody").keydown(function (event) {
			if(event.keyCode=="13"){
				var html="";
				$.ajax({
					url:"workbench/clue/getActivityListByNameNotByClueId.do",
					type: "GET",
					data: {
						clueId:"${c.id}",
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

		$("#qx").click(function () {
			$("input[name=xz]").prop("checked",this.checked);
		})

		$("#activityNotRelationBody").on("click",$("input[name=xz]"),function () {
			$("#qx").prop("checked",$("input[name=xz]").length==$("input[name=xz]:checked").length)
		})
		
		$("#openBundModal").click(function () {
			$("#activitySearchBody").val("")
			$("#activityNotRelationBody").html("")
			$("#bundModal").modal("show")
		})

		$("#bundBtn").click(function () {
			var $xz=$("input[name=xz]:checked")
			var param="clueId=${c.id}&";
			$.each($xz,function (index,ele) {
				param+="id="+ele.value;
				if(index<$xz.length-1){
					param+="&";
				}
			})
			$.ajax({
				url:"workbench/clue/bund.do",
				data:param,
				dataType:"json",
				type:"GET",
				success:function (data) {
					if(data.success){
						$("#qx").attr("checked",false);
						showActivityList();
						$("#bundModal").modal("hide");
					}else {
						alert("关联失败")
					}
				}
			})
		})
		showReamrkList();
		$("#openEditModalBtn").click(function () {
			var id="${c.id}";
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

		$("#updateBtn").click(function () {
			$.ajax({
				url:"workbench/clue/update.do",
				type:"POST",
				data:{
					id: "${c.id}",
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
						$("#editClueModal").modal("hide");
						window.location.href="workbench/clue/detail.do?id="+"${c.id}";
					}else {
						alert("修改失败");
					}
				}
			})
		})

		$("#delBtn").click(function () {
			if(confirm("确定要删除改线索吗?")){
				$.ajax({
					url:"workbench/clue/delete.do",
					data: {id:"${c.id}"},
					type:"POST",
					success:function (data) {
						if(data.success){
							window.location.href="workbench/clue/index.jsp";
						}else {
							alert("删除失败");
						}
					}
				})
			}
		})

		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/clue/saveRemark.do",
				data:{
					clueId:"${c.id}",
					noteContent:$("#remark").val()
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						$("#remark").val("");
						showReamrkList();
					}else {
						alert("添加市场备注失败!");
					}
				}
			})
		})

		$("#updateRemarkBtn").click(function () {
			var id=$("#remarkId").val();
			$.ajax({
				url:"workbench/clue/updateRemark.do",
				data:{
					id:id,
					noteContent:$("#noteContent").val()
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						showReamrkList();
						$("#editRemarkModal").modal("hide");
					}else {
						alert("修改市场备注失败!");
					}
				}
			})
		})


	});

	function showActivityList(){
		var html="";
		$.ajax({
			url:"workbench/clue/getActivityList.do",
			type: "GET",
			data: {
				clueId:"${c.id}"
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

	function unbund(id) {
		if(confirm("确定要解除关联?")){
			$.ajax({
				url:"workbench/clue/deleteByRelationId.do",
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

	function showReamrkList(){
		var remarkHtml="";
		$.ajax({
			url:"workbench/clue/getRemarkList.do",
			data:{id:"${c.id}"},
			success:function (data) {
				$.each(data,function (index,ele) {
					remarkHtml+='<div class="remarkDiv" style="height: 60px;">'
					remarkHtml+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
					remarkHtml+='<div style="position: relative; top: -40px; left: 40px;" >'
					remarkHtml+='<h5 id=e'+ele.id+'>'+ele.noteContent+'</h5>'
					remarkHtml+='<font color="gray">线索</font> <font color="gray">-</font> <b>${c.fullname}-${c.company}</b> <small style="color: gray;"> '+(ele.editFlag=="1"?ele.editTime:ele.createTime)+' 由'+(ele.editFlag=="1"?ele.editBy:ele.createBy)+'</small>'
					remarkHtml+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
					remarkHtml+='<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+ele.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px;color:red;"></span></a>'
					remarkHtml+='&nbsp;&nbsp;&nbsp;&nbsp;'
					remarkHtml+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+ele.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>'
					remarkHtml+='</div>'
					remarkHtml+='</div>'
					remarkHtml+='</div>'
				})
				$("#remarkList").html(remarkHtml);
			}
		})
	}

	function deleteRemark(id) {
		if (confirm("是否删除当条记录?")){
			$.ajax({
				url:"workbench/clue/deleteRemark.do",
				data:{
					id:id
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						showReamrkList();
					}else {
						alert("删除市场备注失败!");
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
	
</script>

</head>
<body>

	<!-- 关联市场活动的模态窗口 -->
	<div class="modal fade" id="bundModal" role="dialog">
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
						    <input type="text" class="form-control" style="width: 300px;" id="activitySearchBody" placeholder="请输入市场活动名称，支持模糊查询">
						    <span class="glyphicon glyphicon-search form-control-feedback"></span>
						  </div>
						</form>
					</div>
					<table id="activityTable" class="table table-hover" style="width: 900px; position: relative;top: 10px;">
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

    <!-- 修改线索的模态窗口 -->
    <div class="modal fade" id="editClueModal" role="dialog">
        <div class="modal-dialog" role="document" style="width: 90%;">
            <div class="modal-content">
                <div class="modal-header">
                    <button type="button" class="close" data-dismiss="modal">
                        <span aria-hidden="true">×</span>
                    </button>
                    <h4 class="modal-title" id="myModalLabel">修改线索</h4>
                </div>
                <div class="modal-body">
                    <form class="form-horizontal" role="form">

                        <div class="form-group">
                            <label for="edit-owner" class="col-sm-2 control-label">所有者<span style="font-size: 15px; color: red;">*</span></label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-owner">
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
                                    <option selected>先生</option>
                                    <option>夫人</option>
                                    <option>女士</option>
                                    <option>博士</option>
                                    <option>教授</option>
                                </select>
                            </div>
                            <label for="edit-surname" class="col-sm-2 control-label">姓名<span style="font-size: 15px; color: red;">*</span></label>
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
									<c:forEach items="${applicationScope.clueStateList}" var="clue">
										<option value="${clue.value}">${clue.text}</option>
									</c:forEach>
                                </select>
                            </div>
                        </div>

                        <div class="form-group">
                            <label for="edit-source" class="col-sm-2 control-label">线索来源</label>
                            <div class="col-sm-10" style="width: 300px;">
                                <select class="form-control" id="edit-source">
                                    <option></option>
									<c:forEach items="${applicationScope.sourceList}" var="clue">
										<option value="${clue.value}">${clue.text}</option>
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
                                    <input type="text" class="form-control time" id="edit-nextContactTime" value="2017-05-01">
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
			<h3>${c.fullname}${c.appellation} <small>${c.company}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 500px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/clue/convert.jsp?id=${c.id}&appellation=${c.appellation}&fullname=${c.fullname}&company=${c.company}&owner=${c.owner}';"><span class="glyphicon glyphicon-retweet"></span> 转换</button>
			<button type="button" id="openEditModalBtn" class="btn btn-default" data-toggle="modal" ><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="delBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: -70px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.fullname}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.owner}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">公司</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.company}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">职位</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.job eq ""?"&nbsp;":c.job}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">邮箱</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.email eq ""?"&nbsp;":c.email}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">公司座机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.phone eq ""?"&nbsp;":c.phone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">公司网站</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.website eq ""?"&nbsp;":c.website}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">手机</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.mphone eq ""?"&nbsp;":c.mphone}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">线索状态</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.state eq ""?"&nbsp;":c.state}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">线索来源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${c.source eq ""?"&nbsp;":c.source}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${c.editBy eq ""?"&nbsp;":c.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${c.editTime eq ""?"&nbsp;":c.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${c.description eq ""?"&nbsp;":c.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${c.contactSummary eq ""?"&nbsp;":c.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${c.nextContactTime eq ""?"&nbsp;":c.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px; "></div>
		</div>
        <div style="position: relative; left: 40px; height: 30px; top: 100px;">
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
	<div style="position: relative; top: 40px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>
		
		<!-- 备注1 -->
		<div id="remarkList">

		</div>

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
	
	<!-- 市场活动 -->
	<div>
		<div style="position: relative; top: 60px; left: 40px;">
			<div class="page-header">
				<h4>市场活动</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table class="table table-hover" style="width: 900px;">
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

						<tr>
							<td>发传单</td>
							<td>2020-10-10</td>
							<td>2020-10-20</td>
							<td>zhangsan</td>
							<td><a href="javascript:void(0);"  style="text-decoration: none;"><span class="glyphicon glyphicon-remove"></span>解除关联</a></td>
						</tr>
					</tbody>
				</table>
			</div>
			
			<div>
				<a href="javascript:void(0);" id="openBundModal" style="text-decoration: none;"><span class="glyphicon glyphicon-plus"></span>关联市场活动</a>
			</div>
		</div>
	</div>
	
	
	<div style="height: 200px;"></div>
</body>
</html>