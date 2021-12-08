$(document).ready(function() {
    console.log("Heyyy")
    $('form').on('submit', function (e){
        e.preventDefault();
        console.log("I'm Here")
    })
});