<%@ Page Language="C#" AutoEventWireup="true" CodeBehind="Residents2.aspx.cs" Inherits="Agera19.Residents2" %>

<%@ OutputCache Duration="1" VaryByParam="none" Location="none" %>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title></title>
    <% 
#if DEBUG
    %>
    <% 
#else
    %>
    <link href="CSS/noCursor.css" rel="stylesheet" type="text/css" />
    <% 
#endif
    %>
    <script type="text/javascript" src="Script/ScrollDiv_new.js"></script>
    <!--OBS! Do not forget to change style sheet when creating new resident page-->
    <link href="CSS/ResidentCSS/residentsStyleKS_agera09.css" rel="stylesheet" runat="server" type="text/css" />
    <script src="Scripts/jquery-1.8.3.js" type="text/javascript"></script>
</head>
<body class="pageBackgroundColor" onload="fixHeader();">
    <form id="form1" runat="server">
    <%--SortOrder value can be 'apartment' or 'lastName1' or 'floor'--%>
    <asp:HiddenField ID="SortOrder" runat="server" Value="floor" />
    <asp:HiddenField ID="SortOrderDescending" runat="server" Value="true" />
    <%--Name order--%>
    <asp:HiddenField ID="LastNameFirst" runat="server" Value="true" />
    <%--FirstNameDisplayOption value can be 'full' or 'initialOnly' or 'initialWithDot'--%>
    <asp:HiddenField ID="FirstNameDisplayOption" runat="server" Value="initialWithDot" />
    <%--ShowAllNames. If 'true' then all names (that are "visible") are shown. --%>
    <asp:HiddenField ID="ShowAllNames" runat="server" Value="false" />
<!--For styling, see residents2.css, (except for a few style properties that are inlined in this aspx, "<hr>" separator between floors trick and navigation buttons) -->
    <div id="theDiv" >
        <asp:Repeater ID="repResidents" runat="server" EnableViewState="False">
            <HeaderTemplate>
                <table id="tblResidents" style="border-collapse: collapse; width: 100%;">
                    <thead>
                                               <tr class="residents-table-head" id="thead">
                            <th class="residents-table-floor-column" id="residents-table-head-floor">
                                Våning
                            </th>
                            <th class="residents-table-name-column" id="residents-table-head-name" >
                                Namn
                            </th>
                            <th class="residents-table-apartment-column" id="residents-table-head-apartment" >
                                Lgh
                            </th>
			    
                        </tr>
                    </thead>
            </HeaderTemplate>
            <FooterTemplate>
                </table></FooterTemplate>
            <ItemTemplate>
                <tr class="oddRow <%# Eval("FloorClass") %>" id="<%# (Container.ItemIndex == 0 ? "firstRow" : "") %>">
                    <td class="residents-table-floor-column">
                        <%# Eval("ObjectFloor") %>
                    </td>
                    <td class="residents-table-name-column">
                        <%# Eval("ResidentNames") %>
                    </td>
                    <td class="residents-table-apartment-column">
                        <%# Eval("Apartment")%>
                    </td>
		    
                </tr>
                <tr >
                    <td colspan="3" style="height:31px">
                        <strike>
                            <div style="top: 50%;width: 100%; padding: 0px;margin: 0;background-color: none;color: transparent"><hr style="border-color: whitesmoke;border-top: 1px;width:100%"/></div>
                        </strike>
                    </td>
                </tr>
            </ItemTemplate>
            <AlternatingItemTemplate>
                <tr class="evenRow  <%# Eval("FloorClass") %>">
                    <td class="residents-table-floor-column">
                        <%# Eval("ObjectFloor")%>
                    </td>
                    <td class="residents-table-name-column">
                        <%# Eval("ResidentNames") %>
                    </td>
                    <td class="residents-table-apartment-column">
                        <%# Eval("Apartment") %>
                    </td>
		 
                </tr>
                <tr>
                    <td colspan="3" style="height:31px">
                        <strike>
                        <div style="top: 50%;width: 100%; padding: 0px;margin: 0;background-color: none;color: transparent"><hr style="border-color: whitesmoke;border-top: 1px;width:100%"/></div>
                        </strike>
                    </td>
                </tr>
            </AlternatingItemTemplate>
        </asp:Repeater>
    </div>
    <div id="divButtons" style="position: absolute; bottom: 0; height: 50px; left: 0; right: 0; background-color: Transparent; z-index: 10">
        <table id="tblButtons" style="width: 100%; height: 100%; background-color: Transparent;" cellpadding="0" cellspacing="0">
            <tr style="border-top: 1px;">
                <td rowspan="2" style="width: 100%;text-align: center; vertical-align: bottom">
                    <%--These two MUST be on the same line - side by side--%>
                    <img alt="" src="Images/Up.png" id="btnScrollUp" onmousedown="scrollDivUp();" onmouseout="stopScroll();" onmouseup="stopScroll();" style="padding-right:10%;" />
                    <img alt="" src="Images/Down.png" id="btnScrollDown" onmousedown="scrollDivDown()" onmouseout="stopScroll()" onmouseup="stopScroll();" style="padding-left:10%" />
                </td>
            </tr>
        </table>
    </div>
    </form>
</body>
<script type="text/javascript">
    function fixHeader() {
        // Show buttons?
        if (theDiv.scrollHeight <= theDiv.scrollTop + theDiv.offsetHeight - $("#tableHeader").offsetHeight) {
            document.getElementById("divButtons").style.display = "none";
            document.getElementById("theDiv").style.bottom = "0";
        }
    }

    $(document).ready(function () {
        var rows = $("#tblResidents tbody").children();
        var count = rows.length;

        var separatorRows = [];
        // Compute which ones should be visible
        for (var ii = 0; ii < count; ++ii) {
            if (!!!rows[ii].className) {
                separatorRows.push({ index: ii, domElem: rows[ii] });
            }
        }

        var toHide = [];

        // Loop through the separators, hide the dom if the element before and after has the same apartment
        for (var jj = 0; jj < separatorRows.length; ++jj) {
            var indexOfSeparator = separatorRows[jj].index;

            // condition for whether the separator should be hidden
            if ($(rows[indexOfSeparator - 1]).children('td:first').text() ==
                $(rows[indexOfSeparator + 1]).children('td:first').text()) {
                toHide.push(separatorRows[jj]);
            }
        }

        // Hide
        for (var kk = 0; kk < toHide.length; ++kk) {
            $(toHide[kk].domElem).toggle(false);
        }

        setTimeout(function () {
                var targetHeight = window.innerHeight;// - $("#tableHeader")[0].clientHeight;

                // We show the buttons if we are on agera19 but not on agera22.
                // If we cannot detect, then we showbuttons
                var showButtons = true;
                if (!!parent && !!(parent.document) && !!(parent.document.body)) {
                    if (parent.document.body.clientWidth > 1900) {
                        showButtons = false;
                    }
                }

				if (showButtons) {
					$("#theDiv").height(targetHeight - $("#divButtons").height());

					// Finally, we seem to be on Agera19 so don't use the "hiding scrollbar styles"
					// It is enough to hide the overflow
					$("#theDiv").css('overflow', 'hidden');
				} else {
					$("#theDiv").height(targetHeight);
				}

                $("#divButtons").toggle(showButtons);
            },
        1000);
    });
</script>
</html>
