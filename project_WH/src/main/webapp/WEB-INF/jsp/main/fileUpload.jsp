<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Insert title here</title>
<!-- jquery -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js" integrity="sha512-v2CJ7UaYy4JwqLDIrZUI/4hqeoQieOmAZNXBeQyjo21dadnwR+8ZaIJVT8EE2iyI61OV8e6M8PP2/4hpQINQ/g==" crossorigin="anonymous" referrerpolicy="no-referrer"></script>

<script>
$(function(){
 	$('#uploadBtn').on("click",function(){
		let formData = new FormData();
		let text = $('#txtfile').val().split(".").pop();	
		if($.inArray(text,['txt']) == -1){
			alert(".txt 파일만 업로드 할 수 있습니다.");
			$('#txtfile').val("");
			return false;
		}
				
		formData.append("uploadFile", $("#txtfile")[0].files[0]);
		
		$.ajax({
	        url : "/fileUpload.do",
	        type : 'post',
	        enctype : 'multipart/form-data',
	        data : formData,
	        contentType : false,
	        processData : false,
	        success : function() {
	        	alert("업로드 완료!");
	        },
	        error:function(request,status,error){					
				console.log("code: " + request.status);
		        console.log("message: " + request.responseText);
		        console.log("error: " + error);
			}
	   	})
			
	});


});

</script>
</head>
<body>
		<!-- 파일업로드 -->
	<div>
		<form id="uploadForm">
			<input type="file" accept=".txt" id="txtfile" name="uploadFile">
		</form>
		<button id="uploadBtn" type="button">업로드</button>
	</div>
</body>
</html>