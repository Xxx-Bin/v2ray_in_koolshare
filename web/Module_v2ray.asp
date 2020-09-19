
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="X-UA-Compatible" content="IE=Edge" />
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<meta HTTP-EQUIV="Pragma" CONTENT="no-cache" />
<meta HTTP-EQUIV="Expires" CONTENT="-1" />
<link rel="shortcut icon" href="images/favicon.png" />
<link rel="icon" href="images/favicon.png" />
<title>软件中心 - 系统工具</title>
<link rel="stylesheet" type="text/css" href="index_style.css" />
<link rel="stylesheet" type="text/css" href="form_style.css" />
<link rel="stylesheet" type="text/css" href="usp_style.css" />
<link rel="stylesheet" type="text/css" href="ParentalControl.css">
<link rel="stylesheet" type="text/css" href="css/icon.css">
<link rel="stylesheet" type="text/css" href="css/element.css">
<link rel="stylesheet" type="text/css" href="res/softcenter.css">
<script type="text/javascript" src="/state.js"></script>
<script type="text/javascript" src="/popup.js"></script>
<script type="text/javascript" src="/help.js"></script>
<script type="text/javascript" src="/validator.js"></script>
<script type="text/javascript" src="/js/jquery.js"></script>
<script type="text/javascript" src="/general.js"></script>
<script type="text/javascript" src="/switcherplugin/jquery.iphone-switch.js"></script>
<script language="JavaScript" type="text/javascript" src="/client_function.js"></script>
<script type="text/javascript" src="/res/softcenter.js"></script>
<script>
var db_v2ray = {}

function init() {
	show_menu(menu_hook);
	get_dbus_data();
}

function get_dbus_data() {
	$.ajax({
		type: "GET",
		url: "/_api/v2ray",
		dataType: "json",
		async: false,
		success: function(data) {
			db_v2ray = data.result[0];
			E("v2ray_enable").checked = db_v2ray["v2ray_enable"] == "1";
			$('#v2ray_version_show i').text(db_v2ray["v2ray_version"])
			$('#v2ray_config').val(db_v2ray["v2ray_config"])
			var status_html = !!db_v2ray["v2ray_status"]?
                              			'<span class="status" style="background-color: green;color:#fff">Y</span>':
                              			'<span class="status" style="background-color: red;color:#fff">X</span>';
			$('#v2ray_status .status').html(status_html)
		}
	});
}

function save() {
	showLoading(3);
	refreshpage(3);
	// collect data from checkbox
	db_v2ray["v2ray_enable"] = E("v2ray_enable").checked ? '1' : '0';
	db_v2ray["v2ray_config"] = $('#v2ray_config').val()

	// post data
	var id = parseInt(Math.random() * 100000000);
	var postData = {"id": id, "method": "v2ray_run.sh", "params": [1], "fields": db_v2ray };
	$.ajax({
		url: "/_api/",
		cache: false,
		type: "POST",
		dataType: "json",
		data: JSON.stringify(postData)
	});
}

function reload_Soft_Center(){
	location.href = "/Module_Softcenter.asp";
}

function menu_hook(title, tab) {
	tabtitle[tabtitle.length -1] = new Array("", "V2RAY");
	tablink[tablink.length -1] = new Array("", "Module_v2ray.asp");
}
</script>
</head>
<style>
.status{
padding:1px 5px;
}
</style>
<body onload="init();">
	<div id="TopBanner"></div>
	<div id="Loading" class="popup_bg"></div>
	<iframe name="hidden_frame" id="hidden_frame" src="" width="0" height="0" frameborder="0"></iframe>
		<input type="hidden" name="current_page" value="Module_v2ray.asp" />
		<input type="hidden" name="next_page" value="Module_v2ray.asp" />
		<input type="hidden" name="group_id" value="" />
		<input type="hidden" name="modified" value="0" />
		<input type="hidden" name="action_mode" value="" />
		<input type="hidden" name="action_script" value="" />
		<input type="hidden" name="action_wait" value="5" />
		<input type="hidden" name="first_time" value="" />
		<input type="hidden" name="preferred_lang" id="preferred_lang" value="CN"/>
		<input type="hidden" name="firmver" value="3.0.0.4"/>
		<table class="content" align="center" cellpadding="0" cellspacing="0">
			<tr>
				<td width="17">&nbsp;</td>
				<td valign="top" width="202">
					<div id="mainMenu"></div>
					<div id="subMenu"></div>
				</td>
				<td valign="top">
					<div id="tabMenu" class="submenuBlock"></div>
					<table width="98%" border="0" align="left" cellpadding="0" cellspacing="0">
						<tr>
							<td align="left" valign="top">
								<table width="760px" border="0" cellpadding="5" cellspacing="0" bordercolor="#6b8fa3" class="FormTitle" id="FormTitle">
									<tr>
										<td bgcolor="#4D595D" colspan="3" valign="top">
											<div>&nbsp;</div>
											<div style="float:left;" class="formfonttitle">软件中心 - V2ray</div>
											<div style="float:right; width:15px; height:25px;margin-top:10px">
												<img id="return_btn" onclick="reload_Soft_Center();" align="right" style="cursor:pointer;position:absolute;margin-left:-30px;margin-top:-25px;" title="返回软件中心" src="/images/backprev.png" onMouseOver="this.src='/images/backprevclick.png'" onMouseOut="this.src='/images/backprev.png'"></img>
											</div>
											<div style="margin:30px 0 10px 5px;" class="splitLine"></div>
											<div class="formfontdesc" id="cmdDesc">来自网络的Project V工具。</div>
											<div class="formfontdesc" id="cmdDesc"></div>
											<table style="margin:10px 0px 0px 0px;" width="100%" border="1" align="center" cellpadding="4" cellspacing="0" bordercolor="#6b8fa3" class="FormTable" id="v2ray_table">
												<thead>
													<tr>
														<td colspan="2">主要选项</td>
													</tr>
												</thead>
												<tr>
													<th>V2ray开关</th>
													<td colspan="2">
														<div class="switch_field" style="display:table-cell;float: left;">
															<label for="v2ray_enable">
																<input id="v2ray_enable" class="switch" type="checkbox" style="display: none;">
																<div class="switch_container">
																	<div class="switch_bar"></div>
																	<div class="switch_circle transition_style">
																		<div></div>
																	</div>
																</div>
															</label>
														</div>
                                                        <div id="v2ray_version_show" style="padding-top:5px;margin-left:20px;margin-top:0px;float: left">
                                                           当前版本： <i></i>
                                                        </div>

                                                         <div id="v2ray_status" style="padding-top:5px;margin-left:20px;margin-top:0px;float: left">
                                                           状态： <span class="status"></span>
                                                        </div>
													</td>
												</tr>
												<tr id="port_tr">
													<th width="35%">配置</th>
													<td>
														<div style="width: 100%;height: 50vh;background: #4D595D;color: #fff;">
															<textarea rows="5"  id="v2ray_config" style="width: 97%;height: 97%;background: #4D595D;color: #fff;"></textarea>
														</div>
													</td>
												</tr>
											</table>
											<div class="apply_gen">
                                        		<span><input class="button_gen" id="cmdBtn" onclick="save();" type="button" value="提交"/></span>
											</div>
											<div id="NoteBox">

											</div>
										</td>
									</tr>
								</table>
							</td>
							<td width="10" align="center" valign="top"></td>
						</tr>
					</table>
				</td>
			</tr>
		</table>
	</td>
	<div id="footer"></div>
</body>
</html>
