var pageCount = 0;
$(document).ready(function () {

    $('.passaport-container').turn({
        width: '62.3vw',
        height: '80vh',
        autoCenter: true
    });

    $("#createidcard").on("click", function () {
        if ($("#religioninput").val() !== undefined && $("#religioninput").val().length > 3) {
            var religioninput = $("#religioninput").val();
            var nameinput = $("#nameinput").val();
            var birthinput = $("#birthinput").val();
            var location = $("#location").val();
            var dateissued = $("#dateissued").val();
            $(".input-container").hide(1000)
            $.post(`https://${GetParentResourceName()}/register`, JSON.stringify({
                religioninput: religioninput,
                nameinput: nameinput,
                birthinput: birthinput,
                location: location,
                dateissued: dateissued,
                image: "https://placehold.co/600x400"
            }));
        } else {
          
        }
    })

    function closeUI() {
        if (!$(".imageinput").is(':hidden')) {
            $(".imageinput").hide();
        } else if (!$('.passaport-container').is(':hidden')) {
            $(".passaport-container").hide()
            let array = []
            for (let index = 0; index < pageCount; index++) {
                var html = $(`#pageid${index}`).val()
                array[index] = html
            }
            var image = $(".firstpage .topinfo .frame .photo").css('background-image');
            $.post(`https://${GetParentResourceName()}/save`, JSON.stringify({ html: array, image: image }));
        } else {
            $(".input-container").hide()
            $.post(`https://${GetParentResourceName()}/close`, JSON.stringify({}));
        }
    }
    $(document).keydown(function (event) {
        if (event.key === "Escape") {
            closeUI()
        }
    });
    $(".imageinput input").on("input", function () {
        var val = $(this).val();
        $(".imageinput .photo").css({
            'background-image': `url('${val}')`
        })
        // $(".firstpage .topinfo .frame .photo").css({
        //     'background-image': `url('${val}')`
        // })
    })

    $(".imageinput button").on("click",function(){
        var val = $(".imageinput input").val();
        $(".firstpage .topinfo .frame .photo").css({
            'background-image': `url('${val}')`
        })
        $(".imageinput").hide();
    })

    window.addEventListener('message', function (event) {
        switch (event.data.action) {
            case "register":
                $("#nameinput").val(event.data.name)
                $("#location").val(event.data.town)
                $("#birthinput").val(event.data.currenttime)
                $("#dateissued").val(event.data.currenttime)
                $("#religioninput").val("Muslim")
                $(".input-container").show()
                break;

            case "openIDCard":
                $('.passaport-container').turn('destroy');
                $(".passaport-container").html(` <div class="page first"></div>
        <div class="page left">
            <div class="firstpage">
                <div class="topinfo">
                    <div class="frame">
                        <div class="photo"></div>
                    </div>
                </div>
                <div class="bottominfo">
                    <div class="group">
                        <div class="label">Firstname Lastname:</div>
                        <input type="text" name="" id="nameidcard" value="${event.data.data.nameinput}" disabled>
                    </div>
                    <div class="group">
                        <div class="label">Town:</div>
                        <input type="text" name="" id="townidcard" value="${event.data.data.location}" disabled>
                    </div>
                    <div class="group">
                        <div class="label">Birth Date:</div>
                        <input type="text" name="" id="birthdateidcard" value="${event.data.data.birthinput}" disabled>
                    </div>
                    <div class="group">
                        <div class="label">Religion:</div>
                        <input type="text" name="" id="religionidcard" value="${event.data.data.religioninput}" disabled>
                    </div>
                    <div class="group">
                        <div class="label">Veriliş tarihi:</div>
                        <input type="text" name="" id="dateissuedidcard" value="${event.data.data.dateissued}" disabled>
                    </div>
                </div>
            </div>
        </div>`);
                pageCount = event.data.pagecount;
                for (let index = 0; index < pageCount; index++) {
                    let leftright = index % 2 == 0 ? "right" : "left"
                    $(".passaport-container").append(`<div class="page ${leftright}">
                        
                        <div class="textarea"><textarea name="" id="pageid${index}">${event.data.data.html?.[index] || ''}</textarea></div>
                    </div>`)

                }

                $(".passaport-container").append('<div class="page last"></div>')

                $('.passaport-container').turn({
                    width: '62.3vw',
                    height: '80vh',
                    autoCenter: true
                });
      
                $(".passaport-container").css({
                    'top': '50%',
                    'left': '50%',
                    'transform': 'translate(-50%,0%)'
                })
                var image = event.data.data.image
                $(".firstpage .topinfo .frame .photo").css({
                    'background-image': `${image}`
                })
                $(".firstpage .topinfo .frame").off("contextmenu")
                $(".firstpage .topinfo .frame").on("contextmenu", function (e) {
                    e.preventDefault();
                    var val = $(".firstpage .topinfo .frame .photo").css("background-image")
                    val = val.match(/url\(["'](https?:\/\/[^"']+)["']\)/)[1];
                    $(".imageinput input").val(val)
                    $(".imageinput .photo").css({
                        'background-image': `url('${val}')`
                    })
                    $(".imageinput").show()
                })
                $(".passaport-container").show()
                break;
        }
    });

});