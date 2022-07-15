<%@ page import="com.bjpowernode.crm.settings.domain.User"%>
<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%
    String basePath = request.getScheme() + "://" + request.getServerName() + ":" + 	request.getServerPort() + request.getContextPath() + "/";
%>
<!DOCTYPE html>
<html>
<head>
    <base href="<%=basePath%>">
    <title>Title</title>
</head>
<script src="ECharts/echarts.min.js"></script>
<script src="jquery/jquery-1.11.1-min.js"></script>
<script>
    $(function () {
        getCharts();
    })

    function getCharts() {

        $.ajax({
            url:"workbench/clue/getCharts.do",
            type:"GET",
            success:function (data) {
                var myChart = echarts.init(document.getElementById('main'));
                var source=new Array(data.total);
                var sourceNu=new Array(data.total);
                $.each(data.dataList,function (index,ele) {
                    source[index]=ele.source;
                    sourceNu[index]=ele.total;
                })
                // 指定图表的配置项和数据
                var option = {
                    xAxis: {
                        type: 'category',
                        boundaryGap: false,
                        data: source
                    },
                    yAxis: {
                        type: 'value'
                    },
                    series: [{
                        data: sourceNu,
                        type: 'line',
                        axisLabel:{
                            interval:0,//横轴信息全部显示
                            //rotate:-15,//-15度角倾斜显示
                        },
                    }]
                };

                // 使用刚指定的配置项和数据显示图表。
                myChart.setOption(option);
            }
        })

    }
</script>
<body>

<div id="main" style="width: 1300px;height:700px;"></div>

</body>
</html>
