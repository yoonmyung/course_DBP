<%@ page contentType="text/html; charset=UTF-8" %>
<%@ page import="java.sql.*"  %>
<%@ page import="java.util.ArrayList"  %>
<html>
<head>
<title>수강신청 입력</title>
<meta charset="UTF-8">
	<meta http-equiv="X-UA-Compatible" content="IE=edge">
  	<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
  	<meta name="description" content="">
  	<meta name="author" content="">
  
	
	<link href="vendor/fontawesome-free/css/all.min.css" rel="stylesheet" type="text/css">
  	<link href="https://fonts.googleapis.com/css?family=Nunito:200,200i,300,300i,400,400i,600,600i,700,700i,800,800i,900,900i" rel="stylesheet">
  	<!-- Custom styles for this template-->
  	<link href="css/sb-admin-2.min.css" rel="stylesheet">
</head>
<style type="text/css">
	html{
		height:100vh;
		overflow:hidden;
	}
	body{
		background:#f8f9fa;
	}
	#accordionSidebar{
		float:left;
	}

	.navbar-expand{
		width:70%;
		float:left;
		text-align:right
	}
	#content-wrapper{
		width:70%;
		height:80vh;
		float:left;
		overflow:auto
	}
	#table-header{
		width:70%;
		float:left;
		overflow:auto
	}
	
	
	select{
		float:right;
	}
	
	#current-credit{
		margin-left:20px;
		margin-right:5px;
		float:left;
	}
	
	.form{
		margin : auto;
		width:100%;
	}
	
	.table{
		background: white;
		margin : auto;
		width:100%;
	}
	th{
		text-align: center;
		word-break: keep-all;
	}
	td{
		text-align: center;
		margin: auto;
		word-break: keep-all;
		white-space:pre-line
	}
</style>

<body>
<%@include file="top.jsp"%>
<div id="table-header">

      <%
      int year_semester = 0;
  	if( request.getParameter("year_semester") == null){
  		year_semester = 201902;
  	}else{
  		year_semester = Integer.parseInt(request.getParameter("year_semester"));
  	}
  	System.out.println(year_semester);
  	if (session_id != null){
  		System.out.println(session_id);
  	}else{
  			System.out.println(session_id);
  			response.sendRedirect("login.jsp");
  	}
  	
  	int nYear = year_semester / 100;
  	int nSemester = year_semester % 100;
  	
  	if(year_semester == 201902){
  		%>
  		<select name="year_semester" onchange="location = this.value;">
  			<option value='select.jsp?year_semester=201902' selected="selected">2019년 2학기</option>	
  			<option value='select.jsp?year_semester=201901' >2019년 1학기</option>
      		<option value='select.jsp?year_semester=201802'>2018년 2학기</option>
      		<option value='select.jsp?year_semester=201801'>2018년 1학기</option>
  		</select>
  		<%
  	}else if(year_semester == 201901){
  		%>
  		<select name="year_semester" onchange="location = this.value;">
  			<option value='select.jsp?year_semester=201902'>2019년 2학기</option>	
  			<option value='select.jsp?year_semester=201901' selected="selected" >2019년 1학기</option>
      		<option value='select.jsp?year_semester=201802'>2018년 2학기</option>
      		<option value='select.jsp?year_semester=201801'>2018년 1학기</option>
  		</select>
  		<%
  	}else if(year_semester == 201802){
  		%>
  		<select name="year_semester" onchange="location = this.value;">
  			<option value='select.jsp?year_semester=201902'>2019년 2학기</option>	
  			<option value='select.jsp?year_semester=201901' >2019년 1학기</option>
      		<option value='select.jsp?year_semester=201802' selected="selected">2018년 2학기</option>
      		<option value='select.jsp?year_semester=201801'>2018년 1학기</option>
  		</select>
  		<%
  	}else if(year_semester == 201801){
  		%>
  		<select name="year_semester" onchange="location = this.value;">
  			<option value='select.jsp?year_semester=201902'>2019년 2학기</option>	
  			<option value='select.jsp?year_semester=201901' >2019년 1학기</option>
      		<option value='select.jsp?year_semester=201802'>2018년 2학기</option>
      		<option value='select.jsp?year_semester=201801' selected="selected">2018년 1학기</option>
  		</select>
  		<%
  	} %>        
<%

String dbdriver = "oracle.jdbc.driver.OracleDriver";
String dburl = "jdbc:oracle:thin:@localhost:1521:orcl";
String user = "SOOK";
String passwd = "2019";

ArrayList<String> courseID = new ArrayList<>();
ArrayList<String> courseName = new ArrayList<>();
ArrayList<String> profID = new ArrayList<>();
ArrayList<Integer> courseCredit = new ArrayList<>();
ArrayList<Integer> courseNumber = new ArrayList<>();
ArrayList<String> courseMajor = new ArrayList<>();
ArrayList<Integer> courseDay1 = new ArrayList<>();
ArrayList<Integer> courseDay2 = new ArrayList<>();
ArrayList<Integer> coursePeriod1 = new ArrayList<>();
ArrayList<Integer> coursePeriod2 = new ArrayList<>();
ArrayList<Integer> courseMax = new ArrayList<>();
ArrayList<Integer> courseCurrent = new ArrayList<>();
int day1;
int day2;
String p_id, sql;

String period1;
String period2;

CallableStatement cstmt;
ResultSet rs;

try {
   Class.forName(dbdriver);
   Connection myConn = DriverManager.getConnection(dburl, user, passwd);
   String stuOrProf = session_id;
   
   if (stuOrProf.length() == 7) {
	sql = "{call getCourseINF(?, ?, ?, ?)}";
	cstmt = myConn.prepareCall(sql);
	cstmt.setString(1, session_id);
	cstmt.setInt(2, nYear);
	cstmt.setInt(3, nSemester);
	cstmt.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
	cstmt.execute();
	rs = (ResultSet)cstmt.getObject(4);
	
	while (rs.next()) {
		courseID.add(rs.getString("c_id"));
		courseName.add(rs.getString("c_name"));
		profID.add(rs.getString("p_id"));
		courseCredit.add(rs.getInt("c_credit"));
		courseNumber.add(rs.getInt("c_number"));
		courseMajor.add(rs.getString("c_major"));
		coursePeriod1.add(rs.getInt("c_period1"));
		coursePeriod2.add(rs.getInt("c_period2"));
		courseDay1.add(rs.getInt("c_day1"));
	    courseDay2.add(rs.getInt("c_day2"));
	}
	   String creditSQL = "{? = call get_stu_credit(?)}";
	  	cstmt = myConn.prepareCall(creditSQL);
	  	cstmt.registerOutParameter(1, java.sql.Types.INTEGER);
	  	cstmt.setString(2, session_id);
	  	cstmt.execute();
		int s_credit = cstmt.getInt(1);
		%>
	<div id="current-credit">
		<p>현재 신청한 학점 : <%= s_credit %></p>
	</div>
<%	
	}
   else {
	sql = "{call getCourseINF_Prof(?, ?, ?, ?)}";
	cstmt = myConn.prepareCall(sql);
	cstmt.setString(1, session_id);
	cstmt.setInt(2, nYear);
	cstmt.setInt(3, nSemester);
	cstmt.registerOutParameter(4, oracle.jdbc.OracleTypes.CURSOR);
	cstmt.execute();
	rs = (ResultSet)cstmt.getObject(4);
	
	while (rs.next()) {
		courseID.add(rs.getString("c_id"));
		courseName.add(rs.getString("c_name"));
		courseCredit.add(rs.getInt("c_credit"));
		courseNumber.add(rs.getInt("c_number"));
		courseMajor.add(rs.getString("c_major"));
		coursePeriod1.add(rs.getInt("c_period1"));
		coursePeriod2.add(rs.getInt("c_period2"));
		courseDay1.add(rs.getInt("c_day1"));
	    courseDay2.add(rs.getInt("c_day2"));
	    courseMax.add(rs.getInt("c_max"));
	    courseCurrent.add(rs.getInt("c_current"));
	}
   }
	%>
</div>



	<!-- Content Wrapper -->
    <div id="content-wrapper" class="d-flex flex-column">

      <!-- Main Content -->
      <div id="content">

        <div class="container-fluid">

          <!-- Page Heading -->
          <div class="d-sm-flex align-items-center justify-content-between mb-4">


   <table class="table table-bordered" width="75%" align="center" border>
<%	
	if (stuOrProf.length() == 7) {
%>
	      <tr>
	         <th>과목번호</th>
	         <th>분반</th>
	         <th>과목명</th>
	         <th>전공</th>
	         <th>교수</th>
	         <th>시간</th>
	         <th>학점</th>
	      </tr>
<%
	      while (!courseID.isEmpty()) {
	         out.println("<tr>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseID.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseNumber.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseName.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseMajor.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         p_id = profID.remove(0);
	         String mySQL = "select p_name from professor where p_id = '" + p_id + "'";
	         Statement prof_stmt = myConn.createStatement();
	 		 ResultSet prof_rs = prof_stmt.executeQuery(mySQL);
	 		 prof_rs.next();
	 		 String p_name = prof_rs.getString("P_NAME");
	         
	         out.println(p_name);
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         period1 = coursePeriod1.remove(0).toString();
	         period2 = coursePeriod2.remove(0).toString();
	         day1 = courseDay1.remove(0);
	         day2 = courseDay2.remove(0);
	         
	         switch(day1) {
	         case 1:
	             out.println("월 " + period1 + "교시");
	             break;
	         case 2:
	             out.println("화 " + period1 + "교시");
	             break;
	         case 3:
	             out.println("수 " + period1 + "교시");
	             break;
	         case 4:
	        	 out.println("목 " + period1 + "교시");
	        	 break;
	         case 5:
	        	 out.println("금 " + period1 + "교시");
	        	 break;
	         }
	         switch(day2) {
	         case 1:
	             out.println("월 " + period2 + "교시");
	             break;
	         case 2:
	             out.println("화 " + period2 + "교시");
	             break;
	         case 3:
	             out.println("수 " + period2 + "교시");
	             break;
	         case 4:
	        	 out.println("목 " + period2 + "교시");
	        	 break;
	         case 5:
	        	 out.println("금 " + period2 + "교시");
	        	 break;
	         }
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseCredit.remove(0));
	         out.println("</td>");
	         
	         out.println("</tr>");
	      }
	}
	else {
%>
	      <tr>
	         <th>과목번호</th>
	         <th>분반</th>
	         <th>과목명</th>
	         <th>전공</th>
	         <th>현재 수강인원</th>
	         <th>최대 수강인원</th>
	         <th>시간</th>
	         <th>학점</th>
	      </tr>
<%
	      while (!courseID.isEmpty()) {
	         out.println("<tr>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseID.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseNumber.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseName.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         out.println(courseMajor.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
			 out.println(courseCurrent.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
			 out.println(courseMax.remove(0));
	         out.println("</td>");
	         
	         out.print("<td align = \"center\" >");
	         period1 = coursePeriod1.remove(0).toString();
	         period2 = coursePeriod2.remove(0).toString();
	         day1 = courseDay1.remove(0);
	         day2 = courseDay2.remove(0);
	         
	         switch(day1) {
	         case 1:
	             out.println("월 " + period1 + "교시");
	             break;
	         case 2:
	             out.println("화 " + period1 + "교시");
	             break;
	         case 3:
	             out.println("수 " + period1 + "교시");
	             break;
	         case 4:
	        	 out.println("목 " + period1 + "교시");
	        	 break;
	         case 5:
	        	 out.println("금 " + period1 + "교시");
	        	 break;
	         }
	         switch(day2) {
	         case 1:
	             out.println("월 " + period2 + "교시");
	             break;
	         case 2:
	             out.println("화 " + period2 + "교시");
	             break;
	         case 3:
	             out.println("수 " + period2 + "교시");
	             break;
	         case 4:
	        	 out.println("목 " + period2 + "교시");
	        	 break;
	         case 5:
	        	 out.println("금 " + period2 + "교시");
	        	 break;
	         }
	         out.println("</td>");
	         
	         out.println("<td align = \"center\" >");
	         out.println(courseCredit.remove(0));
	         out.println("</td>");
	         
	         out.println("</tr>");
	      }
	}
      out.flush();
%>
 <%
   
}catch (ClassNotFoundException e){
   e.printStackTrace();
   System.out.println("jdbc driver 로딩 실패");
}catch (SQLException e){
   e.printStackTrace();
   System.out.println("오라클 연결 실패");
}
%>  </table>   
   
          </div>
        </div>
        <!-- /.container-fluid -->

      </div>
      <!-- End of Main Content -->

    </div>
    <!-- End of Content Wrapper -->
    
   
</body>
</html>