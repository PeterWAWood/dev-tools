JsOsaDAS1.001.00bplist00�Vscript_�var redDir = '/Users/peter/VMShare/Red/red';          // Red repo base dir
var redApp = 'macView';			                      // GUI console bundle name

var evaluate = function (str) {
	system.keystroke(str);
	system.keyCode(36);
	delay(0.3);
};

var red = Application(redApp);
red.activate();
delay(1);

var system = Application('System Events');
red = system.processes[redApp];

var app = Application.currentApplication();
app.includeStandardAdditions = true;

evaluate('change-dir %' + redDir);
delay(0.5);
evaluate('do %quick-test/quick-test.red');

evaluate('***start-run*** "Red tests in GUI console"');
evaluate('do %tests/run-all-simple-gc.red');
evaluate('***end-run***');
                              �jscr  ��ޭ