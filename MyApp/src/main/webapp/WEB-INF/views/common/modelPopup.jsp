<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib uri="http://tiles.apache.org/tags-tiles" prefix="tiles" %>
        <%@ taglib prefix="s" uri="/struts-tags" %>
            <% response.setCharacterEncoding("UTF-8"); %>

<!-- Modal -->
<div class="modal fade" id="confirmStatusModal" tabindex="-1" role="dialog"
aria-labelledby="confirmModalLabel" aria-hidden="true">
<div class="modal-dialog modal-dialog-centered" role="document">
    <div class="modal-content">
        <div class="modal-header bg-warning">
            <h5 class="modal-title" id="confirmModalLabel">Nhắc nhở</h5>
            <button type="button" class="close" data-dismiss="modal" aria-label="Đóng">
                <span aria-hidden="true">&times;</span>
            </button>
        </div>
        <div class="modal-body text-center" id="confirmModalContent">

        </div>
        <div class="modal-footer justify-content-center">
            <button type="button" class="btn btn-secondary" data-dismiss="modal">Hủy bỏ</button>
            <button type="button" class="btn btn-primary" id="confirmStatusBtn">OK</button>
        </div>
    </div>
</div>
</div>