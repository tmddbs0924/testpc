<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Wire</title>

<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="stylesheet" href="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/css/bootstrap.min.css">
<script src="//code.jquery.com/jquery-1.11.1.min.js"></script>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.4.0/jquery.min.js"></script>
<script src="https://maxcdn.bootstrapcdn.com/bootstrap/3.4.0/js/bootstrap.min.js"></script>

<style>
.header{
	margin-bottom:40px;
	font-weight: bold;
}

.container {
	border: 2px solid #000000;
	border-radius: 5px;
	padding: 50px;
	background-color: #d9d9d9;
	width: 400px;
	margin-top: 50px;
}
.btn {
	background-color: #404040; color: white;
	border-radius: 2px;
	width: 250px;
	font-size: 20px;
	margin-top: 20px;
	margin-bottom: 20px;
	
}
.form-group{
	font-size: 20px;
	color: #333333;
}

#sendMoney{
	width:150px;
	font-size:15px;
	text-align:right;
}

#lastResult{
	border:solid 1px black;
	font-weight: bold;
}
</style>

<script type="text/javascript" >
	
 	$(document).ready(function(){
 		
 		// 수취금액 숨김 처리
 		$("#lastResult").hide();
 		
 		// API를 이용한 환율구하기 기능
		exchange(); 
		
	});
	
 	// API를 이용한 환율구하기 기능
	function exchange(){
		
		// 수취금액 숨김 처리
 		$("#lastResult").hide();
		
 		// 수취국가
		var currencies = $("#currencies").val();
 		
 		// API 설정기능
		var endpoint = 'live'
		var access_key = '92199d1b23f936d973470e2e36cef33b';
		
		// Ajax를 위용하여 API값 가져오기
		$.ajax({
			url: 'http://apilayer.net/api/' + endpoint + '?access_key=' + access_key,
			dataType:"json",
			success:function(json){
				
				// 환율값
				var exchangeValue = "";
				
				// 환율값 단위
				var denominations = "";
				
				// 수취금액 단위
				var denominations2 = "";
				
				if(currencies == 'KRW'){
					exchangeValue += json.quotes.USDKRW;
					denominations += 'KRW/USD';
					denominations2 += 'KRW';
				}  
				if(currencies == 'JPY'){
					exchangeValue += json.quotes.USDJPY;
					denominations += 'JPY/USD';
					denominations2 += 'JPY';
				}
				if(currencies == 'PHP'){
					exchangeValue += json.quotes.USDPHP;
					denominations += 'PHP/USD';
					denominations2 += 'PHP';
				}
				 	
				addcomma(exchangeValue);
				$("#denominations").text(denominations);
				$("#denominations2").text(denominations2);
			}
			
		});
		
	} 
	
	//환율 콤마 & 소수점2째자리 표시
	function addcomma(exchangeValue){
		
		// 환율 소수점 2째자리
		var point = Number(exchangeValue).toFixed(2);
		
		// 환율 콤마 정규표현식 사용
		var ev_string = point.toString();
		var ev_parts = ev_string.split('.');
		var regexp = /\B(?=(\d{3})+(?!\d))/g;
		
		// 환율 콤마 & 소수점2째자리 결과값 구하기
		var exchangeResult ="";
		if (ev_parts.length > 1) { 
			exchangeResult = ev_parts[0].replace( regexp, ',' ) + '.' + ev_parts[1]; 
		}
		else { 
			exchangeResult = ev_string.replace( regexp, ',' ); 
		}
	 	
		// 환율 콤마 & 소수점2째자리 결과값
		$("#result").text(exchangeResult);
		
		// 환율 소수점2째자리값
		$("#point").val(point);
	    
	}
	
	// 수취금액 구하는 기능 
	function goSubmit(){
		
		// 송금값 가져오기
		var sendMoney = $("#sendMoney").val();
		// 소수점2째자리 환율값 가져오기
		var point = $("#point").val();
		
		var regexp = /[^0-9]/g;
		var bool = regexp.test(sendMoney);
		
		// 송금값 조건.
		if(sendMoney != null && sendMoney != "" && sendMoney > 0 && sendMoney < 10000){
			
			// 숫자로만 되어있어야 한다.
			if(!bool){
				// 수취금액 구하기
				var totalMoney = sendMoney * point;
				
				// 수취금액 콤마 & 소수점2째자리 구하기
				var tMoney_point = Number(totalMoney).toFixed(2);
				var tMoney_string = tMoney_point.toString();
				var tMoney_parts = tMoney_string.split('.');
				var regexp = /\B(?=(\d{3})+(?!\d))/g;
				
				var tMoneyResult="";
				
				if (tMoney_parts.length > 1) { 
					tMoneyResult = tMoney_parts[0].replace( regexp, ',' ) + '.' + tMoney_parts[1]; 
				}
				else {
					tMoneyResult = tMoney_string.replace( regexp, ',' );
				}
				$("#tMoneyResult").text(tMoneyResult);
				$("#lastResult").show();				
			}
	
		}
		else{
			// 에러 메세지
			alert("송금액이 바르지 않습니다. ( 0보다 큰 숫자로만 이루어져야 하며, 10,000USD초과할 수 없습니다.공백불가! )");
			// 송금액 칸 초기화
			$("#sendMoney").val("");
		}
			
	}
	
</script>
</head>
<body>


<div class="container" >	

	<h1 class="header">환율계산</h1>
	<div class="form-group">송금국가 : 
		<select id="source" >
			<option value="USD">USD</option>
			<!-- <option value="AUD">AUD</option> -->
		</select>
	</div>
	<div class="form-group">수취국가 :  
		<select id="currencies" onchange="exchange()">
			<option value="KRW">KRW</option>
			<option value="JPY">JPY</option>
			<option value="PHP">PHP</option>
		</select>
	</div>
	
	<div class="form-group">환율 : 
		<span id="result"></span> <span id="denominations"></span>
	</div>
	
	<div class="form-group">송금액 : 
		<input id="sendMoney" type="text" value="" placeholder="송금액"></input> USD
	</div>

	<button type="button" class="btn" onClick="goSubmit();">Submit</button>
	
	<input type="hidden" id="point" value="">
	
	<div class="form-group" id="lastResult">수취금액은 
		<span id="tMoneyResult"></span> <span id="denominations2"></span>입니다.
	</div>
	
</div>
</body>
</html>