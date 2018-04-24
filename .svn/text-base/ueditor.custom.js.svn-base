/*!
 * UEditor
 * version: ueditor
 * build:2014.9.15
 */

/**
 * @description 保存
 * @author fzf
 */
UE.commands['save'] = {
	execCommand : function(cmd) {
		var editor = UE.getEditor('editor');
		
		var contentTxt = editor.getContent();
		$.ajax({
			url : "saveDoc.do",
			type : "POST",
			data : {
				"docID" : editor.getOpt("DocID"),
				"docLibID" : editor.getOpt("DocLibID"),
				"topic" : $("#title").val(),
				"content" : contentTxt,
				"folderID" : editor.getOpt("FVID")
			},
			dataType : "json",
			success : function(data) {
				UE.getEditor('editor').trigger('showmessage',{
		            content : data.state,
		            timeout : 2000
		        });
			}
		});
	}
};

/**
 * @description 文本打印(2栏)
 * @author fzf
 */
UE.plugins['textpreview'] = function() {
	var me = this;
	me.commands["textpreview"] = {
		execCommand : function(cmd) {
			var editor = UE.getEditor('editor');
			// 10px-30 12px-25 14px-21
			var setting = {
				a4width : 650,
				a4height : 890,
				splitnum : 2,// 分栏数目
				splitword : 25,// 分栏字数 21个字/14px 25个字/12px 29个字/10px
				splitpadding : 20,// 栏间距
				showLine : false,
				linenumpadding : 10,// 行号间距
				linenumwidth : 0,// 30
				fontsize : 12
			}, content = "^" + editor.getContentTxt().replace(/[\n]/g, '^'), // TODO
			splitWidth = 0, // 分栏的宽度
			wordsWidth = 0, // 实际字体占的宽度
			pageLines = 0, // 每页行数
			totalLines = 0, // 总行数
			totalsplits = 0, // 总分栏数
			pagenum = 1;// 总页数

			// alert(content);
			splitWidth = Math.floor((setting.a4width - setting.splitpadding
					* (setting.splitnum - 1))
					/ setting.splitnum) - 2;
			wordsWidth = (setting.fontsize) * setting.splitword;
			if (wordsWidth > splitWidth - setting.linenumpadding
					- setting.linenumwidth) {
				alert("可能会超出打印宽度！！");
				return;
			}

			// 打开文本打印窗口
			// if(textPreviewWindow.closed){
			var textPreviewWindow = window.open("", "文本打印");// ,"text","status,height=200,width=300"
			// }
			textPreviewWindow.focus();

			var wordHeight = setting.fontsize + 6;// 行高
			pageLines = Math.floor(setting.a4height / wordHeight);

			var html = [
					'<style type="text/css">',
					'.main{width:' + setting.a4width + 'px;height:'
							+ setting.a4height
							+ 'px;margin-bottom:22px;border:1px solid #000;}',
					'.split{width:' + splitWidth
							+ 'px;height:100%;float:left;font-size:'
							+ setting.fontsize + 'px;line-height:'
							+ (setting.fontsize + 6) + 'px;margin-right:10px;}',
					'.linenumTxt{text-align:right;font-size:13px;display:inline-block;width:'
							+ setting.linenumwidth + 'px;margin-right:'
							+ setting.linenumpadding + 'px;}',
					'.pageNext{page-break-after: always;}', '</style>' ];

			var size = 0;// 当前打印结果字数
			// html.push("&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;");
			var lineWord = 0;// 每行字体，控制换行
			var lineEmpty = 0;// 每行满4个空格时，lineWord-1
			var lines = 0;// 总行数，控制分栏
			var splits = 0;// 总分栏数，控制分页
			var lineTxt = [];
			html.push('<div class="main">');
			html.push('<div class="split">');
			for ( var i = 0; i < content.length; i++) {
				var c = content.charAt(i);
				if (c == " ") {
					lineEmpty++;
					lineTxt.push("&nbsp;");
					if (lineEmpty % 4 == 0) {
						lineWord++;
						if (lineWord % setting.splitword == 0) {// br
							lines++;
							lineTxt.push("<br/>");
							if (setting.showLine) {
								html.push('<span class="linenumTxt">' + lines
										+ '</span>');
							}
							html.push(lineTxt.join(''));
							lineWord = 0;
							lineEmpty = 0;
							lineTxt = [];
							if (lines % pageLines == 0) {// split
								html.push('</div>');
								splits++;
								if (splits % setting.splitnum == 0) {
									html.push('</div>');
									html.push('<div class="pageNext"></div>');
									html.push('<div class="main">');
								}
								html.push('<div class="split">');
							}
						}
					}
					// alert(lineTxt.join(''));
				} else if (c == "^") {
					lines++;
					lineTxt.push("<br/>");// &nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
					// alert('<span
					// class="linenumTxt">'+lines+'</span>'+lineTxt.join(''));
					if (setting.showLine) {
						html.push('<span class="linenumTxt">' + lines
								+ '</span>');
					}
					html.push(lineTxt.join(''));
					lineWord = 2;
					lineEmpty = 8;
					lineTxt = [ '&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;' ];
					if (lines % pageLines == 0) {// split
						html.push('</div>');
						splits++;
						if (splits % setting.splitnum == 0) {
							html.push('</div>');
							html.push('<div class="pageNext"></div>');
							html.push('<div class="main">');
						}
						html.push('<div class="split">');
					}
				} else {
					lineWord++;
					lineTxt.push(c);
					if (lineWord % setting.splitword == 0) {// br
						lines++;
						lineTxt.push("<br/>");
						// alert('<span
						// class="linenumTxt">'+lines+'</span>'+lineTxt.join(''));

						if (setting.showLine) {
							html.push('<span class="linenumTxt">' + lines
									+ '</span>');
						}
						html.push(lineTxt.join(''));
						lineWord = 0;
						lineEmpty = 0;
						lineTxt = [];
						if (lines % pageLines == 0) {// split
							html.push('</div>');
							splits++;
							if (splits % setting.splitnum == 0) {
								html.push('</div>');
								html.push('<div class="pageNext"></div>');
								html.push('<div class="main">');
							}
							html.push('<div class="split">');
						}
					}
					;
				}

				// end for
			}
			if (lineTxt.length != 0) {
				lines++;
				if (setting.showLine) {
					html.push('<span class="linenumTxt">' + lines + '</span>');
				}
				html.push(lineTxt.join(''));
			}
			html.push('</div>');
			html.push('</div>');

			html
					.push('<OBJECT classid="CLSID:8856F961-340A-11D0-A96B-00C04FD705A2" height="0" id="wb" name="wb"></OBJECT>');
			html.push('<script type="text/javascript">');
			html.push('wb.execwb(7,1);');
			html.push('</script>');

			// html.push('</body></html>');

			// alert(html.join(''));

			textPreviewWindow.document.write(html.join(''));
			textPreviewWindow.document.close();
		},
		queryCommandState : function(command) {
			var domUtils = baidu.editor.dom.domUtils;
			var images = domUtils.getElementsByTagName(me.body, "img"), tables = domUtils
					.getElementsByTagName(me.body, "table");
			if (images.length > 0 || tables.length > 0) {
				return -1;
			}
			return 0;
		}
	};
};

/**
 * @description 新建版本 每次操作DOM对象，保存时，保存XML流
 * @author fzf
 */
UE.commands['newversion'] = {
	execCommand : function(cmd) {
		var editor = UE.getEditor('editor');
		var contentTxt = editor.getContent();
		// 保存后台，生成XML文件
		var saveData = [
				{
					name : 'UserID',
					value : editor.getOpt("UserID")
				},
				{
					name : 'UserName',
					value : editor.getOpt("UserName")
				},
				{
					name : 'DocID',
					value : editor.getOpt("DocID")
				},
				{
					name : 'DocLibID',
					value : editor.getOpt("DocLibID")
				},
				{
					name : 'Note',
					value : 'note'
				},
				{
					name : 'Content',
					value : '<body xmlns="http://www.w3.org/1999/xhtml">'
							+ contentTxt + '</body>'
				} ];
		$.ajax({
			url : './addVersion.do',
			type : 'post',
			dataType : "json",
			data : saveData,
			traditional : true,
			success : function(data) {
				alert(UE.getEditor('editor').getLang('versionManage.newVersionSucc'));
			}
		});
	}
};

/**
 * @description 修改痕迹
 * @author fzf
 */
UE.commands['modifytrace'] = {
	execCommand : function(cmd) {
		var editor = UE.getEditor('editor');
		$.ajax({
			url : './getTrace.do',
			type : 'post',
			data : {
				"docID":editor.getOpt("DocID"),
				"docLibID":editor.getOpt("DocLibID")
			},
			traditional : true,
			success : function(data) {
				openTextDialog(
						'~/dialogs/versionhistory-custom/versionContent.html',
						data, '修改痕迹');
			}
		});
	},
	queryCommandState : function(command) {
		// TODO 如果至少 一个 版本内容的话，才可用
		/**
		 * var xmlDoc = loadXmlDOc(reversionXmlString); var versions =
		 * xmlDoc.getElementsByTagName('version'); if( versions.length <1 ){
		 * return -1; } return 0;
		 */
		return 0;
	}
};

/**
 * @description 文本比较
 * @author fzf
 */
UE.commands['textcompare'] = {
		execCommand:function (cmd) {
			//打开窗口
			var iframeUrlText = '~/dialogs/versionhistory-custom/textcompare.html';
			var dialog = new baidu.editor.ui.Dialog(baidu.editor.utils.extend({
				iframeUrl:iframeUrlText.replace('~/', UE.getEditor('editor').options.UEDITOR_HOME_URL || ''),
				editor:UE.getEditor('editor'),
				className:'edui-for-textcompare',
				title:"文本比较",
				holdScroll:false,
				fullscreen: false
			}, {
				buttons:[
					{
						className:'edui-okbutton',
						label:UE.getEditor('editor').getLang("ok"),
						editor:UE.getEditor('editor'),
						onclick:function () {
							//获得版本号						
							var iframe0 = dialog.getDom('iframe');
							var v1 = iframe0.contentWindow.document.getElementById("v1"),
								v2 = iframe0.contentWindow.document.getElementById("v2");
							if( v1.selectedIndex == v2.selectedIndex ){
								alert(UE.getEditor('editor').getLang('versionManage.differVersion'));								
								return;
								
							}
							//alert("v1="+v1.value+"，v2="+v2.value);						
							dialog.close(true);
							
							//TODO 传给后台,打开比较结果！！！！
							openTextDialog('~/dialogs/versionhistory-custom/versionContent.html','<p>哈哈，这是比较结果</p>','文本比较');
							/**
							$.ajax({
								url: 			'',
								type: 			'post',			
								data: 			'v1=' +v1+"&v2="+v2
								traditional: 	true,			
								success: 		function(data){
									//if(data.success){
										openTextDialog('~/dialogs/versionhistory/versionContent.html',data.text,'文本比较');
									//}
								}
							});
							*/
						}
					},
					{
						className:'edui-cancelbutton',
						label:UE.getEditor('editor').getLang("cancel"),
						editor:UE.getEditor('editor'),
						onclick:function () {
							dialog.close(false);
						}
					}
				]
			} 
			));
			dialog.render();
			dialog.open();
			
		},
		queryCommandState:function (command) {
			// TODO 如果至少 一个 版本内容的话，才可用
			/**
			var xmlDoc = loadXmlDOc(reversionXmlString);
			var versions = xmlDoc.getElementsByTagName('version');
			if( versions.length <1 ){
				return -1;
			}*/
			return 0;
		}
	};

/**
 * @description 修订
 * @author fzf
 */
UE.plugins['ajustment'] = function() {
	var me = this, // 修订按钮
	selectTxt = '', flag = 0;
	// 加事件的不是me,是整个编辑区域的keyup
	/**
	 * me.addListener('reset',function(){ flag = 0; });
	 */

	// 获得选中内容
	function getSelectTxt(type, evt) {
		var range = UE.getEditor('editor').selection.getRange();
		range.select();
		selectTxt = UE.getEditor('editor').selection.getText();
	}

	// 添加修订痕迹
	function addAjustment(type, evt) {
		var key = evt.keyCode;
		// alert("弹起时："+key);
		// alert("弹起时："+selectTxt);
		// TODO如果有选中的文字或内容，则取出内容，添加<strike>

		// 1、删除光标后的内容
		// 2、如果有选中的内容，则标为删除
		if (key == 8) {// backspace
			if (selectTxt.length != 0) {
				evt.returnValue = false;
				// 如果是表格，就不执行这一行。
				UE.getEditor('editor').execCommand(
						'insertHtml',
						'<strike style=\'color:#ff0000;\' class=\'deleted\'>'
								+ selectTxt + '</strike>');
			} else {
				evt.returnValue = false;

				var rng, text;
				if (document.createRange) {
					// alert("chrome");
					// UE.getEditor('editor').execCommand('selectall');

					var ht = '<b style="color:red;">1</b>';
					var rng = $("#edui1_iframeholder").find("iframe").get(0).contentWindow
							.getSelection().getRangeAt(0);
					var frg = rng.createContextualFragment(ht);
					rng.insertNode(frg);
					// rng.setStartBefore(frg);

					// var editorIframe =
					// $("#edui1_iframeholder").find("iframe").get(0).contentWindow;
					// var rng = editorIframe.getSelection().getRangeAt(0);

					// var tmpText = editorIframe.document.createTextNode('');
					// rng.insertNode( tmpText );
					// rng.setStartBefore(tmpText);

					// rng.setStart(node,-2);
					// rng.select();

					// alert($("#edui1_iframeholder").html());
					// alert($("#edui1_iframeholder").find("iframe").length);

					// alert($("#edui1_iframeholder").find("iframe").get(0).contentWindow.document);

					// var rangeStart =
					// $("#edui1_iframeholder").find("iframe").get(0).contentWindow.document.body.selectionStart;

					// alert("chrome=="+rangeStart);
					// var rangeEnd = UE.getEditor('editor').selectionEnd;

					// UE.getEditor('editor').setSelectionRange(rangeStart - 1,
					// rangeStart);//后一个字

				} else {
					rng = document.selection.createRange();
					rng.moveStart("character", -2);
					rng.select();// 显式选择文本区域（选中前一个字符）
					text = rng.text;
				}
				// alert(text);

				// var caretPos = rng.duplicate();
				document.selection.clear();
				UE.getEditor('editor').execCommand(
						'insertHtml',
						'<strike style=\'color:#ff0000;\' class=\'deleted\'>'
								+ text + '</strike>');
				// 光标向前移动一个，不然不能连续删除
				rng.moveEnd("character", -1);
				rng.select();
			}
			// TODO 判断表格，背景色为浅红色
			// TODO 删除图片

		}
		// 1、删除光标后的内容
		if (key == 46) {// delete???????笔记本的keycode?????????
			// alert("delete");
			if (selectTxt.length != 0) {
				evt.returnValue = false;
				UE.getEditor('editor').execCommand(
						'insertHtml',
						'<strike style=\'color:#ff0000;\' class=\'deleted\'>'
								+ selectTxt + '</strike>');
			} else {
				evt.returnValue = false;
				var rng = document.selection.createRange();
				rng.moveEnd("character", 1);
				rng.select();// 显式选择文本区域（选中后一个字符）
				var text = rng.text;// 获得选中的文本（后一个字符）
				// alert(text);

				var caretPos = rng.duplicate();
				document.selection.clear();
				UE.getEditor('editor').execCommand(
						'insertHtml',
						'<strike style=\'color:#ff0000;\' class=\'deleted\'>'
								+ text + '</strike>');
			}
		}

		// 字母，数字，小键盘数字，符号
		// 1、输入的所有内容，都标为新增
		// 2、如果有选中的内容，则标为删除
		// 3、各种 UE.getEditor('editor').execCommand('insertHtml',
		// value)新增（图片，表格，时间，分页符）
		// 4、粘贴
		// 5、回车键
		// 6、如果父元素已经删掉了，输入的内容全是删除的
		if ((key >= 65 && key <= 90) || (key >= 48 && key <= 57)
				|| (key >= 96 && key <= 111) || (key >= 186 && key <= 192)
				|| (key >= 219 && key <= 222)) {
			// alert("数字或字母或符号");
			// alert();
			// 先删掉选中的内容，再添加输入的内容，不能阻止默认事件
		}
	}
	me.commands['ajustment'] = {
		execCommand : function(cmdName) {
			// alert("flag="+flag);
			if (flag) {
				flag = 0;
				me.removeListener('keydown', addAjustment);
				me.removeListener('beforekeydown', getSelectTxt);
				// alert("应用修订结果！");

				// TODO 保存修订结果
				// 添加的文字
				var addeds = $(
						".added",
						document.getElementById('ueditor_0').contentWindow.document.body);
				addeds.css({
					"color" : "#000",
					"text-decoration" : "none"
				});
				addeds.find("span").css({
					"color" : "#000",
					"text-decoration" : "none"
				});
				addeds.find("p").css({
					"color" : "#000",
					"text-decoration" : "none"
				});

				// 添加的表格
				var addedTDs = $(
						"td.added",
						document.getElementById('ueditor_0').contentWindow.document.body);
				addeds.css("background-color", "#fff");

				addeds.removeClass("added");
				addedTDs.removeClass("added");
				// TODO added img
				var addedImgs = $(
						".addedImg",
						document.getElementById('ueditor_0').contentWindow.document.body);
				addedImgs.removeClass("addedImg");
				// *********************************************************************************

				// 删除文字
				$(
						".deleted",
						document.getElementById('ueditor_0').contentWindow.document.body)
						.remove();

				// 删除table(跨行，跨列问题)
				$(
						"table",
						document.getElementById('ueditor_0').contentWindow.document.body)
						.each(
								function() {
									var rowTds = $(this).find(
											"td[class*='deletedRow']");
									// alert(rowTds.length);
									var rowIndexArr = [];
									for ( var i = 0; i < rowTds.length; i++) {
										var tdClass = rowTds.eq(i)
												.attr("class");
										rowIndexArr.push(tdClass.substring(10));
										if (rowTds.get(i).rowSpan > 1) {
											rowTds.get(i).rowSpan--;
										} else {
											rowTds.get(i).parentNode
													.removeChild(rowTds.get(i));
										}
									}
									rowIndexArr = rowIndexArr.distinct();
									// alert("rowIndexArr-----"+rowIndexArr);
									for ( var i = 0; i < rowIndexArr.length; i++) {
										var index = rowIndexArr[i];
										if (i != 0) {
											index--;
										}
										$(this).get(0).deleteRow(index);
									}
								});

				// 删除列
				var colTds = $(
						"td[class*='deletedCol']",
						document.getElementById('ueditor_0').contentWindow.document.body);
				// alert(tds.length);
				for ( var i = 0; i < colTds.length; i++) {
					// alert(tds.get(i).rowSpan);
					if (colTds.get(i).colSpan > 1) {
						colTds.get(i).colSpan--;
					} else {
						colTds.get(i).parentNode.removeChild(colTds.get(i));
					}
				}

				// TODO delete img
				// *********************************************************************************

				return;
			}
			me.addListener('keydown', addAjustment);
			// if( evt != undefined && evt.keyCode == 37) {return;}
			me.addListener('beforekeydown', getSelectTxt);// TODO
															// 左箭头事件不好用了！！！！！evt.keyCode
															// == 37
			// alert("给整个编辑区域加keyup监听");
			flag = 1;
		},
		queryCommandState : function() {
			return flag;
		},
		notNeedUndo : 1
	};
};

/**
 * @description 提取标题
 * @author fzf
 */
UE.plugins['extracttitle'] = function() {
	var me = this;

	me.commands['extracttitle'] = {
		execCommand : function(cmdName) {
			alert("提取标题");
		},
		queryCommandState : function() {
			var text = UE.getEditor('editor').selection.getText();
			if (text.length <= 0) {
				return -1;
			}
			return 0;
		}
	};
	me.addshortcutkey("extracttitle", "113");
};

/**
 * @description 提取引题
 * @author fzf
 */
UE.plugins['extractguidetitle'] = function() {
	var me = this;

	me.commands['extractguidetitle'] = {
		execCommand : function(cmdName) {
			alert("提取引题");
		},
		queryCommandState : function() {
			var text = UE.getEditor('editor').selection.getText();
			if (text.length <= 0) {
				return -1;
			}
			return 0;
		}
	};
	me.addshortcutkey("extractguidetitle", "119");
};

/**
 * @description 提取副题
 * @author fzf
 */
UE.plugins['extractsubtitle'] = function() {
	var me = this;

	me.commands['extractsubtitle'] = {
		execCommand : function(cmdName) {
			alert("提取副题");
		},
		queryCommandState : function() {
			var text = UE.getEditor('editor').selection.getText();
			if (text.length <= 0) {
				return -1;
			}
			return 0;
		}
	};
	me.addshortcutkey("extractsubtitle", "83");
};

/**
 * @description 提取作者
 * @author fzf
 */
UE.plugins['extractauthor'] = function() {
	var me = this;
	me.commands['extractauthor'] = {
		execCommand : function(cmdName) {
			alert("提取作者");
		},
		queryCommandState : function() {
			var text = UE.getEditor('editor').selection.getText();
			if (text.length <= 0) {
				return -1;
			}
			return 0;
		}
	};
	me.addshortcutkey("extractauthor", "118");
};

/**
 * @description 提取关键字
 * @author fzf
 */
UE.plugins['extractkey'] = function() {
	var me = this;

	me.commands['extractkey'] = {
		execCommand : function(cmdName) {
			alert("提取关键字");
		},
		queryCommandState : function() {
			var text = UE.getEditor('editor').selection.getText();
			if (text.length <= 0) {
				return -1;
			}
			return 0;
		}
	};
	me.addshortcutkey("extractkey", "75");
};

// 数组去重
Array.prototype.distinct = function() {
	var clone, newArr = [], n = 0;
	if (this.length < 2)
		return;
	clone = this;
	for ( var i = 0, len = this.length; i < len; i++) {
		for ( var j = i + 1, len2 = clone.length; j < len2; j++) {
			if (this[i] !== clone[j]) {
				n++;
			}
		}
		if (n == (len - i - 1)) {
			newArr.push(this[i])
		}
		n = 0;
	}
	return newArr;
}

/* 打开窗口 */
function openTextDialog(url, content, windowTitle) {
	viewVersionContent = content;
	var dialog = new baidu.editor.ui.Dialog(baidu.editor.utils.extend({
		iframeUrl : url.replace('~/',
				UE.getEditor('editor').options.UEDITOR_HOME_URL || ''),
		editor : UE.getEditor('editor'),
		className : 'edui-for-versioncontent',
		title : windowTitle,
		holdScroll : false,
		fullscreen : false
	}, {}));
	dialog.render();
	dialog.open();
}
// 获得窗口路径 参数
function GetQueryString(name) {
	var reg = new RegExp("(^|&)" + name + "=([^&]*)(&|$)");
	var r = window.location.search.substr(1).match(reg);
	if (r != null)
		return unescape(r[2]);
	return null;
}
