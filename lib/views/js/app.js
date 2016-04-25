$(document).ready(function () {

    $('.end-game-section').hide();
    $('.score-table-section').hide();
    $('#score-table').hide();
    var score = {turns: 0, name: '', result: ''};

    $('.hidden-elem').each(function () {
        $(this).removeClass('hidden-elem');
    });

    $('#turns').text('5');

    var setProperties = function (pie_variable) {
        pie_variable.clockwise = false;
        pie_variable.wheelRadius = pie_variable.wheelRadius * 1;
        pie_variable.createWheel();
    };

    var getWheelSelected = function (wheelNum) {
        return $("[class|=wheelnav-piemenu" + wheelNum + "-slice-selected]");
    };

    var getWheelValue = function (wheelNum) {
        return $("[class|=wheelnav-piemenu" + wheelNum + "-title-selected] tspan").text();
    };

    var getPieMenuBackground = function (piemenuNumber) {
        return $("[class|=wheelnav-piemenu" + piemenuNumber + "-slice-basic]");

    };

    var setWheelColor = function (wheelNum, success) {
        switch (success) {
            case " ":
                getPieMenuBackground(wheelNum).css('fill', '#e51818');
                getWheelSelected(wheelNum).css('fill', '#e51818');
                break;
            case "-":
                getPieMenuBackground(wheelNum).css('fill', '#e5d308');
                getWheelSelected(wheelNum).css('fill', '#e5d308');
                break;
            case "+":
                getPieMenuBackground(wheelNum).css('fill', '#14e510');
                getWheelSelected(wheelNum).css('fill', '#14e510');
                break;
        }
    };

    var setWheelResult = function (resultMatch) {
        for (var i = 0; i < resultMatch.length; i++) {
            setWheelColor(i + 1, resultMatch    [i]);
        }

    };

    var getResponseParams = function (params) {
        return params.split('%')
    };

    var switchWinLose = function (winLose) {
        if (winLose) {
            $('#lose').hide();
            $('#congratulation').show();

        } else {
            $('#congratulation').hide();
            $('#lose').show();
        }
        switchViewsGameEndGame()
    };

    var switchViewsGameEndGame = function () {
        $('.code-section').slideToggle(200);
        $('.end-game-section').slideToggle(200);

    };

    var switchEndGameSaveViews = function () {
        $(".end-game-section").slideToggle(200);
        $(".score-table-section").slideToggle(200);
    };

    var switchSaveScoreTable = function() {
        $("#save_score_from").slideToggle(100);
        $("#score-table").slideToggle(200);
    };

    var disableHint = function () {
        $("button[name='hint']").prop('disabled', true);
        $("select[name='hint_option']").prop('disabled', true);

    };

    var showScoreTable = function(score) {
        switchSaveScoreTable();
        $(score).each(function(index, element){
            $('#scores').append('<tr><td> '+element.name+' </td> <td> '+element.success +
                '</td> <td>' + element.turns + '</td></tr>');
        });
    };

    var piemenu1 = new wheelnav('piemenu1');
    setProperties(piemenu1);
    var piemenu2 = new wheelnav('piemenu2');
    setProperties(piemenu2);
    var piemenu3 = new wheelnav('piemenu3');
    setProperties(piemenu3);
    var piemenu4 = new wheelnav('piemenu4');
    setProperties(piemenu4);


    $("button[name='try']").click(function () {
        result = "";
        for (var i = 1; i < 5; i++) {
            result += getWheelValue(i);
        }
        $.post("/turn", {code: result}).done(function (data) {
            arrayOfParams = getResponseParams(data);
            resultMatch = arrayOfParams[0];
            turns = arrayOfParams[1];
            success = arrayOfParams[2];
            $('#turns').text(turns);
            switch (success) {
                case 'win':
                    switchWinLose(true);
                    break;
                case 'lose':
                    switchWinLose(false);
                    break;
            }
            setWheelResult(resultMatch);
        });
    });

    $("button[name='hint']").click(function () {
        hintMessage = $('#hint_option option:selected').val();
        $.post('/hint', {message: hintMessage}).done(function (data) {
            $('#hint').text(data);
            $('#hint-count').text('0');
            $('.hint-answer').text(data);
            $('.turns #hint').parent().show();
            disableHint();
        });
    });

    $("button[name='save']").click(function () {
        switchEndGameSaveViews();
    });

    $('#save_score_from').submit(function(event) {
        event.preventDefault();
        playerName = $("input[name='user_name']").val();
        $.post('/save_score', {name: playerName}).done(function(data) {
            showScoreTable(JSON.parse(data));
        });
    });


});
