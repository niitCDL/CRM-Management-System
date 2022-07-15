<%@ page import="java.util.Map" %>
<%@ page import="java.util.List" %>
<%@ page import="com.bjpowernode.crm.settings.domain.DicValue" %>
<%@ page import="com.bjpowernode.crm.workbench.domain.Tran" %>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
	String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
	List<DicValue> dvList= (List<DicValue>) application.getAttribute("stageList");
	Map<String,String> pMap= (Map<String, String>) application.getAttribute("Stage2Possibility");
	int point=0;
	for (int i=0;i<dvList.size();i++){
		DicValue dv = dvList.get(i);
		String stage = dv.getValue();
		String possibility = pMap.get(stage);
		if("0".equals(possibility)){
			point=i;
			break;
		}
	}


%>
<!DOCTYPE html>
<html>
<head>
	<base href="<%=basePath%>">
<meta charset="UTF-8">

<link href="jquery/bootstrap_3.3.0/css/bootstrap.min.css" type="text/css" rel="stylesheet" />

<style type="text/css">
.mystage{
	font-size: 20px;
	vertical-align: middle;
	cursor: pointer;
}
.closingDate{
	font-size : 15px;
	cursor: pointer;
	vertical-align: middle;
}
</style>
	
<script type="text/javascript" src="jquery/jquery-1.11.1-min.js"></script>
<script type="text/javascript" src="jquery/bootstrap_3.3.0/js/bootstrap.min.js"></script>

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
		
		
		//阶段提示框
		$(".mystage").popover({
            trigger:'manual',
            placement : 'bottom',
            html: 'true',
            animation: false
        }).on("mouseenter", function () {
                    var _this = this;
                    $(this).popover("show");
                    $(this).siblings(".popover").on("mouseleave", function () {
                        $(_this).popover('hide');
                    });
                }).on("mouseleave", function () {
                    var _this = this;
                    setTimeout(function () {
                        if (!$(".popover:hover").length) {
                            $(_this).popover("hide")
                        }
                    }, 100);
                });
		showTranHistoryList();
		showReamrkList();

		$("#deleteTranBtn").click(function () {
			if(confirm("你确定要删除这条交易吗?")){
				$.ajax({
					url: "workbench/transaction/deleteTran.do",
					data:{id: "${t.id}"},
					type:"POST",
					dataType: "json",
					success:function (data) {
						if(data.success){
							window.location.href="workbench/transaction/index.jsp";
						}else {
							alert("删除交易失败!");
						}
					}
				})
			}
		})

		$("#saveRemarkBtn").click(function () {
			$.ajax({
				url:"workbench/transaction/saveRemark.do",
				data:{
					tranId:"${t.id}",
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
				url:"workbench/transaction/updateRemark.do",
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

	function showTranHistoryList() {
		var html="";
		$.ajax({
			url:"workbench/transaction/getTranHistoryListById.do",
			data:{"tranId":"${t.id}"},
			dataType:"json",
			type:"GET",
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<tr>';
					html+='<td>'+ele.stage+'</td>';
					html+='<td>'+ele.money+'</td>';
					html+='<td>'+ele.possibility+'</td>';
					html+='<td>'+ele.expectedDate+'</td>';
					html+='<td>'+ele.createTime+'</td>';
					html+='<td>'+ele.createBy+'</td>';
					html+='</tr>';
				})
				$("#tranHistoryBody").html(html);
			}
		})
	}

	function changeStage(stage,i) {
		$.ajax({
			url:"workbench/transaction/changeStage.do",
			data:{
				id:"${t.id}",
				stage:stage,
				money:$("#money").html(),
				expectedDate: $("#expectedDate").html()
			},
			dataType:"json",
			type:"GET",
			success:function (data) {
				if(data.success){
					$("#stage").html(data.t.stage);
					$("#possibility").html(data.t.possibility);
					$("#editBy").html(data.t.editBy+"&nbsp;&nbsp;");
					$("#editTime").html(data.t.editTime);
					changeIcon(stage,i);
					showTranHistoryList();
				}else {
					alert("改变阶段失败!")
				}
			}
		})
	}

	function editRemark(id) {
		$("#remarkId").val(id);
		$("#noteContent").val($("#e"+id).html());
		$("#editRemarkModal").modal("show")
	}

	function changeIcon(stage,index1) {
		var currentStage=stage;
		var currentPossibility=$("#possibility").html();
		var index=index1;
		var point="<%=point%>";
		if(currentPossibility=="0"){
			for (var i=0;i<point;i++){
				//黑圈
				var s=$("#"+i);
				s.removeClass();
				s.addClass("glyphicon glyphicon-record mystage");
				s.css("color","#000000");
			}
			for (var i=point;i<<%=dvList.size()%>;i++){
				//红叉
				if(i==index){
					var s=$("#"+i);
					s.removeClass();
					s.addClass("glyphicon glyphicon-remove mystage");
					s.css("color","#FF0000");
				}else {
					var s=$("#"+i);
					s.removeClass();
					s.addClass("glyphicon glyphicon-remove mystage");
					s.css("color","#000000");
				}
			}
		}else {
			for (var i=0;i<point;i++){
				if(i<index){
					var s=$("#"+i);
					s.removeClass();
					s.addClass("glyphicon glyphicon-ok-circle mystage");
					s.css("color","#90F790");
				}else if(index==i){
					var s=$("#"+i);
					s.removeClass();
					s.addClass("glyphicon glyphicon-map-marker mystage");
					s.css("color","#90F790");
				}else {
					var s=$("#"+i);
					s.removeClass();
					s.addClass("glyphicon glyphicon-record mystage");
					s.css("color","#000000");
				}
			}
			for (var i=point;i<<%=dvList.size()%>;i++){
				//黑叉
				var s=$("#"+i);
				s.removeClass();
				s.addClass("glyphicon glyphicon-remove mystage");
				s.css("color","#000000");
			}
		}
	}

	function showReamrkList() {
		var html="";
		$.ajax({
			url:"workbench/transaction/getRemarkList.do",
			data:{id:"${t.id}"},
			success:function (data) {
				$.each(data,function (index,ele) {
					html+='<div class="remarkDiv" style="height: 60px;">'
					html+='<img title="zhangsan" src="image/user-thumbnail.png" style="width: 30px; height:30px;">'
					html+='<div style="position: relative; top: -40px; left: 40px;" >'
					html+='<h5 id="e'+ele.id+'">'+ele.noteContent+'</h5>'
					html+='<font color="gray">交易</font> <font color="gray">-</font> <b>${t.customerName}-${t.name}</b> <small style="color: gray;">'+(ele.editFlag==1?ele.editTime:ele.createTime)+'由'+(ele.editFlag==1?ele.editBy:ele.createBy)+'</small>'
					html+='<div style="position: relative; left: 500px; top: -30px; height: 30px; width: 100px; display: none;">'
					html+='<a class="myHref" href="javascript:void(0);" onclick="editRemark(\''+ele.id+'\')"><span class="glyphicon glyphicon-edit" style="font-size: 20px; color: red;"></span></a>'
					html+='&nbsp;&nbsp;&nbsp;&nbsp;'
					html+='<a class="myHref" href="javascript:void(0);" onclick="deleteRemark(\''+ele.id+'\')"><span class="glyphicon glyphicon-remove" style="font-size: 20px; color: red;"></span></a>'
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
				url:"workbench/transaction/deleteRemark.do",
				data:{
					id:id
				},
				dataType:"json",
				type:"POST",
				success:function (data) {
					if(data.success){
						showReamrkList();
					}else {
						alert("删除交易备注失败!");
					}
				}
			})
		}
	}
	
	
</script>

</head>
<body>
	
	<!-- 返回按钮 -->
	<div style="position: relative; top: 35px; left: 10px;">
		<a href="javascript:void(0);" onclick="window.history.back();"><span class="glyphicon glyphicon-arrow-left" style="font-size: 20px; color: #DDDDDD"></span></a>
	</div>
	
	<!-- 大标题 -->
	<div style="position: relative; left: 40px; top: -30px;">
		<div class="page-header">
			<h3>${t.customerName}-${t.name} <small>￥${t.money}</small></h3>
		</div>
		<div style="position: relative; height: 50px; width: 250px;  top: -72px; left: 700px;">
			<button type="button" class="btn btn-default" onclick="window.location.href='workbench/transaction/edit.do?id=${t.id}';"><span class="glyphicon glyphicon-edit"></span> 编辑</button>
			<button type="button" class="btn btn-danger" id="deleteTranBtn"><span class="glyphicon glyphicon-minus"></span> 删除</button>
		</div>
	</div>

	<!-- 阶段状态 -->
	<div style="position: relative; left: 40px; top: -50px;">
		阶段&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
		<%
			Tran tran= (Tran) request.getAttribute("t");
			String currentstage = tran.getStage();
			String currentpossibility = tran.getPossibility();

			if("0".equals(currentpossibility)){
				for(int i=0;i<dvList.size();i++){
					DicValue dv = dvList.get(i);
					String stage = dv.getValue();
					String possibility = pMap.get(stage);
					if("0".equals(possibility)){
						if(currentstage.equals(stage)){
		%>
				<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					  class="glyphicon glyphicon-remove mystage"
					  data-toggle="popover" data-placement="bottom"
					  data-content="<%=stage%>" style="color: #FF0000;">
				</span>
		-----------
		<%

						}else {
		%>
				<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					  class="glyphicon glyphicon-remove mystage"
					  data-toggle="popover" data-placement="bottom"
					  data-content="<%=stage%>" style="color: #000000;">
				</span>
		-----------
		<%				}
					}else {
		%>
				<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					  class="glyphicon glyphicon-record mystage"
					  data-toggle="popover" data-placement="bottom"
					  data-content="<%=stage%>" style="color: #000000;">
				</span>
		-----------
		<%			}
				}
			}else {
				int index=0;
				for(int i=0;i<dvList.size();i++){
					DicValue dv = dvList.get(i);
					String stage = dv.getValue();
					if(currentstage.equals(stage)){
						index=i;
						break;
					}
				}
				for(int i=0;i<dvList.size();i++){
					DicValue dv = dvList.get(i);
					String stage = dv.getValue();
					String possibility = pMap.get(stage);
					if("0".equals(possibility)){
		%>
				<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					  class="glyphicon glyphicon-remove mystage"
					  data-toggle="popover" data-placement="bottom"
					  data-content="<%=stage%>" style="color: #000000;">
				</span>
		-----------
		<%			}else {
						if(i==index){
		%>
				<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					  class="glyphicon glyphicon-map-marker mystage"
					  data-toggle="popover" data-placement="bottom"
					  data-content="<%=stage%>" style="color: #90F790;">
				</span>
		-----------
		<%				}else if(i<index){
		%>
				<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					  class="glyphicon glyphicon-ok-circle mystage"
					  data-toggle="popover" data-placement="bottom"
					  data-content="<%=stage%>" style="color: #90F790;">
				</span>
		-----------
		<%
						}else {
		%>
				<span id="<%=i%>" onclick="changeStage('<%=stage%>','<%=i%>')"
					  class="glyphicon glyphicon-record mystage"
					  data-toggle="popover" data-placement="bottom"
					  data-content="<%=stage%>" style="color: #000000;">
				</span>
		-----------
		<%
						}
					}
				}
			}
		%>

<%--		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="资质审查" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="需求分析" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="价值建议" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-ok-circle mystage" data-toggle="popover" data-placement="bottom" data-content="确定决策者" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-map-marker mystage" data-toggle="popover" data-placement="bottom" data-content="提案/报价" style="color: #90F790;"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="谈判/复审"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="成交"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="丢失的线索"></span>
		-----------
		<span class="glyphicon glyphicon-record mystage" data-toggle="popover" data-placement="bottom" data-content="因竞争丢失关闭"></span>
		-------------%>
		<span class="closingDate" id="expectedDate">${t.expectedDate}</span>
	</div>
	
	<!-- 详细信息 -->
	<div style="position: relative; top: 0px;">
		<div style="position: relative; left: 40px; height: 30px;">
			<div style="width: 300px; color: gray;">所有者</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.owner}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">金额</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="money">${t.money eq ""?"&nbsp;":t.money}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 10px;">
			<div style="width: 300px; color: gray;">名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.name}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">预计成交日期</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.expectedDate}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 20px;">
			<div style="width: 300px; color: gray;">客户名称</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.customerName}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">阶段</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="stage">${t.stage}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 30px;">
			<div style="width: 300px; color: gray;">类型</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.type eq ""?"&nbsp;":t.type}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">可能性</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b id="possibility">${t.possibility}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 40px;">
			<div style="width: 300px; color: gray;">来源</div>
			<div style="width: 300px;position: relative; left: 200px; top: -20px;"><b>${t.source eq ""?"&nbsp;":t.source}</b></div>
			<div style="width: 300px;position: relative; left: 450px; top: -40px; color: gray;">市场活动源</div>
			<div style="width: 300px;position: relative; left: 650px; top: -60px;"><b>${t.activityName eq null?"&nbsp;":t.activityName}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px;"></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -60px; left: 450px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 50px;">
			<div style="width: 300px; color: gray;">联系人名称</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${empty t.contactsName?"&nbsp;":t.contactsName}</b></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 60px;">
			<div style="width: 300px; color: gray;">创建者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>${t.createBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;">${t.createTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 70px;">
			<div style="width: 300px; color: gray;">修改者</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b id="editBy">${t.editBy eq ""?"&nbsp;":t.editBy}&nbsp;&nbsp;</b><small style="font-size: 10px; color: gray;" id="editTime">${t.editTime eq ""?" ":t.editTime}</small></div>
			<div style="height: 1px; width: 550px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 80px;">
			<div style="width: 300px; color: gray;">描述</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					${t.description eq ""?"&nbsp;":t.description}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 90px;">
			<div style="width: 300px; color: gray;">联系纪要</div>
			<div style="width: 630px;position: relative; left: 200px; top: -20px;">
				<b>
					&nbsp;${t.contactSummary eq ""?"&nbsp;":t.contactSummary}
				</b>
			</div>
			<div style="height: 1px; width: 850px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
		<div style="position: relative; left: 40px; height: 30px; top: 100px;">
			<div style="width: 300px; color: gray;">下次联系时间</div>
			<div style="width: 500px;position: relative; left: 200px; top: -20px;"><b>&nbsp;${t.nextContactTime eq ""?"&nbsp;":t.nextContactTime}</b></div>
			<div style="height: 1px; width: 400px; background: #D5D5D5; position: relative; top: -20px;"></div>
		</div>
	</div>
	
	<!-- 备注 -->
	<div style="position: relative; top: 100px; left: 40px;">
		<div class="page-header">
			<h4>备注</h4>
		</div>

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
								<label for="edit-description" class="col-sm-2 control-label">内容</label>
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
	
	<!-- 阶段历史 -->
	<div>
		<div style="position: relative; top: 100px; left: 40px;">
			<div class="page-header">
				<h4>阶段历史</h4>
			</div>
			<div style="position: relative;top: 0px;">
				<table id="activityTable" class="table table-hover" style="width: 900px;">
					<thead>
						<tr style="color: #B3B3B3;">
							<td>阶段</td>
							<td>金额</td>
							<td>可能性</td>
							<td>预计成交日期</td>
							<td>创建时间</td>
							<td>创建人</td>
						</tr>
					</thead>
					<tbody id="tranHistoryBody">
<%--						<tr>
							<td>资质审查</td>
							<td>5,000</td>
							<td>10</td>
							<td>2017-02-07</td>
							<td>2016-10-10 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>需求分析</td>
							<td>5,000</td>
							<td>20</td>
							<td>2017-02-07</td>
							<td>2016-10-20 10:10:10</td>
							<td>zhangsan</td>
						</tr>
						<tr>
							<td>谈判/复审</td>
							<td>5,000</td>
							<td>90</td>
							<td>2017-02-07</td>
							<td>2017-02-09 10:10:10</td>
							<td>zhangsan</td>
						</tr>--%>
					</tbody>
				</table>
			</div>
			
		</div>
	</div>
	
	<div style="height: 200px;"></div>
	
</body>
</html>