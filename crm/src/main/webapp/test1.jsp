<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <title></title>
</head>
<script src="jquery/jquery-1.11.1-min.js"></script>
<script>
    $(function () {
        $.ajax({
            url:"workbench/",
            data:{},
            dataType:"json",
            type:"GET",
            success:function (data) {

            }
        })

        $(".time").datetimepicker({
            minView: "month",
            language:  'zh-CN',
            format: 'yyyy-mm-dd',
            autoclose: true,
            todayBtn: true,
            pickerPosition: "bottom-left"
        });
    })
</script>
<body>

</body>
</html>
