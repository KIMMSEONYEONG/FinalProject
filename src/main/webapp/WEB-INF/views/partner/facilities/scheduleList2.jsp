<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>

<script src="https://code.jquery.com/jquery-3.6.0.min.js"></script>

<%
    int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
%>

<style>
    .table th {
        text-align: center;
    }
    .table td {
        text-align: center;
    }
	#filter-form .card-body {
	    cursor: pointer; /* 커서가 포인터로 변경됩니다. */
	}
	.form-check-input {
    width: 20px; /* 체크박스 너비 */
    height: 20px; /* 체크박스 높이 */
    border: 2px solid #d3d3d3; /* 체크박스 테두리 색상 (연한 회색) */
    border-radius: 4px; /* 체크박스 모서리 둥글게 */
    background-color: #f8f9fa; /* 체크박스 기본 배경색 */
    transition: background-color 0.3s, border-color 0.3s; /* 부드러운 전환 효과 */
}
</style>


<div class="body-wrapper">
    <div class="container-fluid">
        	<!-- 상단 카드 시작-->
	        <div class="card bg-info-subtle shadow-none position-relative overflow-hidden mb-4">
	           <div class="card-body px-4 py-3">
	             <div class="row align-items-center" style="margin-top:20px;">
	               <div class="col-9">
	                 <h4 class="fw-semibold mb-8">일정 관리</h4>
	                 <nav aria-label="breadcrumb">
	                   <ol class="breadcrumb">
	                     <li class="breadcrumb-item">
	                       <a class="text-muted text-decoration-none" href="../main/index.html">DashBoard</a>
	                     </li>
	                     <li class="breadcrumb-item" aria-current="page">일정 관리</li>
	                   </ol>
	                 </nav>
	               </div>
	               <div class="col-3">
	                 <div class="text-center mb-n4">
	                   <img src="${pageContext.request.contextPath }/resources/assets/images/logos/symbol-01.png" alt="modernize-img" class="img-fluid" style="width: 120px; height: auto;">
	                 </div>
	               </div>
	             </div>
	           </div>
	        </div>
	        <!-- 상단 카드 끝 -->
	        	        
        	<!-- 풀캘린더 하드코딩 START -->
			<div class="card">
				<div class="card-body">
					<div class="card">
            			<div id="calendar"></div>
        			</div>
				</div>
			</div>
			<!-- 풀캘린더 하드코딩 END -->
			
            <!-- 셀렉트 및 검색창 시작 -->
            <div class="row mb-4 align-items-center">
	            <div class="col-md-12 d-flex justify-content-end align-items-center">
	                <form action="/partner/facilities/scheduleList" method="get" class="position-relative me-2" id="searchForm">
	                	<input type="hidden" name="page" id="page"/>
	                    <input type="text" class="form-control product-search ps-5 pe-5" id="input-search" name="searchWord" placeholder="제목 또는 내용" value="${searchWord}" style="width:280px;" />
	                    <i class="ti ti-search position-absolute top-50 start-0 translate-middle-y fs-6 text-dark ms-3"></i>
	                </form>
	                <button type="button" class="btn btn-primary" id="searchBtn">검색</button>
	            </div>
            </div>
            <!-- 셀렉트 및 검색창 끝 -->
            <div class="table-responsive mb-4 border rounded-1 mt-3">
                <table class="table table-hover text-nowrap mb-0 align-middle" style="table-layout: fixed;">
                    <colgroup>
                        <col style="width: 10%;">
                        <col style="width: 15%;">
                        <col style="width: 35%;">
                        <col style="width: 25%;">
                        <col style="width: 15%;">
                    </colgroup>
                    <thead class="text-dark fs-4">
                        <tr>
                            <th><h6 class="fs-4 fw-semibold mb-0"></h6></th>
                            <th><h6 class="fs-4 fw-semibold mb-0">요청구분</h6></th>
                            <th><h6 class="fs-4 fw-semibold mb-0">접수내용</h6></th>
                            <th><h6 class="fs-4 fw-semibold mb-0">점검위치</h6></th>
                            <th><h6 class="fs-4 fw-semibold mb-0">상태</h6></th>
                        </tr>
                    </thead>
					<tbody>
					    <c:choose>
					        <c:when test="${empty pagingVO.dataList}">
					            <tr>
					                <td colspan="5">일정 내역이 존재하지 않습니다.</td>
					            </tr>
					        </c:when>
							<c:otherwise>
							    <c:set var="totalCount" value="${pagingVO.totalRecord}" />
							    <c:set var="pageSize" value="10" /> <!-- 페이지당 게시글 수 -->
							    <c:set var="startIndex" value="${(pagingVO.currentPage - 1) * pageSize}" />
							    <c:set var="currentCount" value="${totalCount - startIndex}" />
							    <c:forEach items="${pagingVO.dataList}" var="schedule" varStatus="status">
							        <tr>
						            	<td>
				                          <input class="form-check-input contact-chkbox primary" type="checkbox" name="selectedInNos" id="checkbox-${schedule.inNo}" value="${schedule.inNo}" onclick="event.stopPropagation();">
				                        </td>
							            <td class="text-center"><p class="mb-0 fw-normal fs-4">${schedule.inGoal}</p></td>
							            <td class="text-center"><p class="mb-0 fw-normal fs-4">${schedule.inReception}</p></td> <!-- 왼쪽 정렬 -->
							            <td class="text-center"><p class="mb-0 fw-normal fs-4">${schedule.inPlace}</p></td>
							            <td>
							                <c:choose>
							                    <c:when test="${schedule.inState == 'Y'}">
							                        <span class="badge bg-primary-subtle text-primary" style="margin-left:10px">점검 완료</span>
							                    </c:when>
							                    <c:when test="${schedule.inState == 'H'}">
							                        <span class="badge bg-success-subtle text-success" style="margin-left:10px">점검 중</span>
							                    </c:when>
							                    <c:when test="${schedule.inState == 'N'}">
							                        <span class="badge bg-warning-subtle text-warning" style="margin-left:10px">점검 요청</span>
							                    </c:when>
							                </c:choose>
							            </td>
							        </tr>
							    </c:forEach>
							</c:otherwise>
					    </c:choose>
					</tbody>
                </table>
            </div>
		    <div class="text-end mb-3">
			    <c:choose>
			        <c:when test="${not empty searchWord}">
			            <a href="/partner/facilities/scheduleList" class="btn btn-outline-primary">목록</a>
			        </c:when>
			        <c:otherwise>
			        	<a href="javascript:void(0)" class="btn btn-primary" onclick="handleBlindProcessing()">접수 확인</a>
			        </c:otherwise>
			    </c:choose>
			</div>

			<!-- Pagination 시작 -->
			<div class="d-flex justify-content-center" style="margin-top: 20px;" id="pagingArea">
			    <nav aria-label="...">
			        ${pagingVO.pagingHTML }
			    </nav>
			</div>
			<!-- Pagination 끝 -->
    </div>
</div>

<!-- 반려 사유 작성 알림 모달 -->
<div class="modal fade" id="blindCkModal" tabindex="-1" aria-labelledby="vertical-center-modal" aria-hidden="true">
    <div class="modal-dialog modal-sm">
        <div class="modal-content modal-filled bg-warning-subtle">
            <div class="modal-body p-4">
                <div class="text-center text-warning">
                    <i class="ti ti-alert-octagon fs-7"></i>
                    <h4 class="mt-2">알림</h4>
                    <p class="mt-3">접수 처리할 항목을 선택해주세요!</p>
                    <button type="button" class="btn btn-light my-2" data-bs-dismiss="modal">닫기</button>
                </div>
            </div>
        </div>
    </div>
</div>

<link href="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.10.1/main.min.css" rel="stylesheet" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/fullcalendar/5.10.1/main.min.js"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.6.0/jquery.min.js"></script>

<script type="text/javascript">
function selectFilter(value) {
    document.getElementById('selectedItem').value = value; // 전체 선택일 경우 값이 없게 설정
    document.getElementById('filter-form').submit();
}

$(function(){
	$("#pagingArea").on("click", "a", function(e){
		e.preventDefault();
		var pageNo = $(this).data("page");
		$("#searchForm").find("#page").val(pageNo);
		$("#searchForm").submit();
	});
});


function handleBlindProcessing() {
    // 체크된 체크박스 수집
    const selectedInNos = Array.from(document.querySelectorAll('input[name="selectedInNos"]:checked'))
        .map(checkbox => checkbox.value);

    if (selectedInNos.length === 0) {
        $('#blindCkModal').modal('show'); // 모달 표시
        return; // 선택된 항목이 없으면 중단
    }

    // 선택된 항목을 폼에 추가
    const form = document.createElement('form');
    form.method = 'POST';
    form.action = '/partner/facilities/scheduleCheck'; // 블라인드 처리할 URL로 변경

    // 선택된 항목을 폼에 추가
    selectedInNos.forEach(inNo => {
        const input = document.createElement('input');
        input.type = 'hidden';
        input.name = 'inNos';
        input.value = inNo;
        form.appendChild(input);
    });
    
    // SweetAlert2로 확인 메시지 표시
    Swal.fire({
        title: '접수 확인',
        text: '해당 접수 건을 접수 처리하시겠습니까?',
        icon: 'info',
        showCancelButton: true,
        confirmButtonText: '확인',
        cancelButtonText: '취소',
        customClass: {
            cancelButton: 'btn btn-outline-primary',
            confirmButton: 'btn btn-primary me-2'
        },
        buttonsStyling: false
    }).then((result) => {
        if (result.isConfirmed) {
            document.body.appendChild(form);
            form.submit(); // 폼 제출
        }
    });
}


document.addEventListener('DOMContentLoaded', function() {
	var calendarEl = document.getElementById('calendar');
	var calendar = new FullCalendar.Calendar(calendarEl, {
		initalView : 'dayGridMonth',
		events: [
		    {
		    	id : '1',
		      title:'물류창고 대청소',
		      start:'2024-11-11',
		      end:'2024-11-13',
		      color:'#f4bab9'
		    },
		    {
		    	id : '2',
		      title:'서울-도쿄(하네다) 할인  팝업',
		      start:'2024-11-04',
		      end:'2024-11-09',
		      color:'#d5f1d8'
		    },
		    {
		    	id : '3',
		      title:'구찌 실적 보고서 제출',
		      start:'2024-11-20',
		      color:'#bcbbf9'
		    },
		    {
		    	id : '4',
		      title:'Whaleport 공항 대청소',
		      start:'2024-11-25',
		      end:'2024-11-25',
		      color:'#bcbbf9'
		    },
		    {
		    	id : '5',
		      title:'빽다방 팝업 회의',
		      start:'2024-11-25',
		      end:'2024-11-29',
		      color:'#d5f1d8'
		    }
		  ]
	});
	calendar.render();
});
</script>
