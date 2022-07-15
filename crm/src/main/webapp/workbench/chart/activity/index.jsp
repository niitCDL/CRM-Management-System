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
            url:"workbench/activity/getCharts.do",
            type:"GET",
            success:function (data) {
                var myChart = echarts.init(document.getElementById('main'));
                // 指定图表的配置项和数据
                var option = {
                    title: {
                        text: '市场活动统计表',
                        subtext: '市场活动',
                        left: 'center'
                    },
                    tooltip: {
                        trigger: 'item'
                    },
                    legend: {
                        orient: 'vertical',
                        left: 'left',
                    },
                    series: [
                        {
                            name: '市场活动来源',
                            type: 'pie',
                            radius: '50%',
                            data:data.dataList,
                            emphasis: {
                                itemStyle: {
                                    shadowBlur: 10,
                                    shadowOffsetX: 0,
                                    shadowColor: 'rgba(0, 0, 0, 0.5)'
                                }
                            }
                        }
                    ]
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
