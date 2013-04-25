$(function()
{

    //
    //
    // ***** Control progress bar *****
    //
    //
    function updateProgress(percentage)
    {

        // Set progress bar's width and update text to the correct percentage
        $('#msch-progress').css('width', '' + percentage + '%');
        $('#msch-progress_text').html('' + percentage + '% Complete');

    }

    //
    //
    // ***** Reset progress bar *****
    //
    //
    updateProgress(0);

    //
    //
    // ***** Scroll around the quiz *****
    //
    //
    function scrollQuiz(location)
    {

        // Variables for scrolling amounts and duration
        // Ideally Sharepoint should scroll to an element's position not by a set amount, in case the Sharepoint layout ever changes
        var duration = 600;
        var sharepointTop = 450;
        var sharepointBottom = 2000;

        // Top or bottom of quiz?
        switch (location) {

            // Top of questions, for new page
            case 'top' :

                // Target different elements based on whether you're inside Sharepoint or not
                if ($('#s4-workspace').length > 0) {

                    // Sharepoint
                    $('#s4-workspace').animate({scrollTop: sharepointTop}, duration);

                } else {

                    // Local
                    $('html, body').animate({scrollTop: $('#quiz-top').offset().top}, duration);

                }

            break;

            // Bottom of quiz, to see Next buttons
            case 'bottom' :

                // Target different elements based on whether you're inside Sharepoint or not
                if ($('#s4-workspace').length > 0) {

                    // Sharepoint
                    $('#s4-workspace').animate({scrollTop: sharepointBottom}, duration);

                } else {

                    // Local
                    $('html, body').animate({scrollTop: $('#quiz-bottom').offset().top}, duration);

                }

            break;

        }

    }


    // count how many steps there are
    var step_count = $('div[id*="step-"]').size();


    $('input[id*="submit_"]').click(function(e) {

        //prevent default link behaviour
        e.preventDefault();

        //console.log("button clicked " + this.id);
        next_step(this.id.substring(7))     
    });

    // hide everything that needs hiding for the initial step
    $('div[id*="step-"]').hide();
    $('#results').hide();
    $( ".progress-wrap" ).css("display", "none");
    $( "#start-quiz" ).click(function(e) {

            // Prevent the link executing
            e.preventDefault();
            first_step();
     });


    function first_step() {
        $('#intro').fadeOut('fast');


        window.setTimeout(function(){
            $('#step-1').fadeIn('slow');
            $( ".progress-wrap" ).fadeIn('slow');
        }, 200);
    }

    function next_step(current_step) {
        var progress = Math.round(current_step * (100 / step_count));
        // Show your progress
        updateProgress(progress);

        $('#step-'+current_step).fadeOut('fast');
        
        if(current_step < step_count) {
            // Remove screen 1, show screen 2
            var t = window.setTimeout(function(){
                $('#step-'+(eval(current_step)+1)).fadeIn('slow');
            }, 200);
        } else {
            //console.log("Doing final step");
            final_step();
        }
    }


    function final_step() {
          $("#quiz_form").bind("ajax:success",
            function(evt, data, status, xhr){
              //this assumes the action returns an HTML snippet
              handle_results(data.correct_answers);
          }).bind("ajax:error", 
            function(evt, data, status, xhr){
              //do something with the error here
          });

        $('#quiz_form').submit();

    }

    function handle_results(correctAnswers) {
        var totalAnswers = step_count;
        // You now know how many answer there are and how many you got right, so turn that into a percentage
        var percentageCorrect = Math.round((correctAnswers / totalAnswers) * 100);
        
        // Pass mark is 70% - show pass or fail message
        if (percentageCorrect >= 70) {

            // Set pass title and score message
            $('#quiz-results-message').html('Well done!');
            $('#quiz-results-text').html('You scored ' + percentageCorrect + '% - you obviously paid attention and have successfully passed the quiz!');

            // Submit score (pass)
            MySiteQuizSubmit(percentageCorrect, true);

            // You've passed, so no need to show the Try Again button
            $('#quiz-retry-button').hide();

        } else {

            // Set failure title and score message
            //$('#quiz-results-message').html('So close!');
            //$('#quiz-results-text').html("You scored " + percentageCorrect + "%");
            $('#quiz-results-text').html("<h3>You scored <span class=\"large\">" + percentageCorrect + "%</span>  " + "(" + correctAnswers + "/" + totalAnswers + ")</h3>");
            $('#quiz-attempts-text').html("<h3>YOU HAVE 3 ATTEMPTS LEFT</h3>");
            //$('#quiz-results-text').html("<h4>You scored " + percentageCorrect + "%</h3>");
            //$('#quiz-attempts-text').html("<h3>You have 3 attempts remaining</h4>");  

            // Submit score (fail)
            MySiteQuizSubmit(percentageCorrect, false);

            // Make sure the Try Again button is visible
            $('#quiz-retry-button').show();

        }

        // Remove screen X, show screen X+1
        $('#results').slideDown();

        // Remove the progress bar
        $('#msch-progress_bar').hide();

    }

    //
    //
    // ***** Disable the quiz page submit buttons until you've answered enough questions on each page *****
    //
    //
    $('.msch-quiz-button').attr('disabled', 'disabled');
    $('.msch-quiz-button').addClass('msch-quiz-button-disabled');
    $('.msch-quiz-button').fadeTo(0, 0.5);

    // Reverse the above for the Try Again button at the end of the quiz
    $('#quiz-retry-button').removeAttr('disabled');
    $('#quiz-retry-button').removeClass('msch-quiz-button-disabled');
    $('#quiz-retry-button').fadeTo(0, 1);

    //
    //
    // ***** Watch for the user clicking an answer radio button to count answers on each page *****
    //
    //

    // Select all radio buttons the user could click to answer
    var answerCheckRadioButtons = $('#msch-container input[type=radio]');

    // Add a click action to them
    answerCheckRadioButtons.on('click', function() {
        var answerCounter = $('#msch-container input[type=radio]:checked').size();
        var numberOfQuestionsPerPage = 1;
        var targetQuizPage = answerCounter / numberOfQuestionsPerPage;
        var targetButton = $('#submit_' + targetQuizPage);

        // Turn that target into an addressable submit button, then remove the disabled class from that button
        // If you have the correct button, switch it back on and remove the disabled classes
        if (targetButton) {
            targetButton.removeAttr('disabled');
            targetButton.removeClass('msch-quiz-button-disabled');
            targetButton.fadeTo(0, 1);

            // Kill the reference to the target button, ready for the next click
            targetButton = null;
        }
    });
});