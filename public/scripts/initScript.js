$(".loader").show();
$(document).ready(function () {
	$("#sidenav").metisMenu();

	// set sibar value
	if (sidebarValue) toggleSidebar(true);

	$(".btn-toggle").click(function () {
		const isToggled = $("body").hasClass("toggled");
		toggleSidebar(!isToggled);

		if ($(window).width() >= 1199) saveUserData('is_sidebar_closed', !isToggled);
	});

	$(".sidebar-close").on("click", function () {
		$("body").removeClass("toggled");
	});

	$(window).on("scroll", function () {
		if ($(this).scrollTop() > 60) {
			$(".top-header .navbar").addClass("sticky-header");
		} else {
			$(".top-header .navbar").removeClass("sticky-header");
		}
	});

	for (
		let e = window.location,
			o = $(".metismenu li a")
				.filter(function () {
					return this.href == e;
				})
				.addClass("")
				.parent()
				.addClass("mm-active");
		o.is("li");

	)
		o = o.parent("").addClass("mm-show").parent("").addClass("mm-active");

	function initMain() {
		const url = window.location.pathname;
		loadPageContent(url);
	}
	initMain();

	$("a[data-link]").click(spaHref);

	window.onpopstate = function (event) {
		if (event.state && event.state.url) {
			loadPageContent(event.state.url);
		}
	};
});

function toggleSidebar(state) {
	if (state) {
		$("body").addClass("toggled");
		$(".sidebar-wrapper").hover(
			function () {
				$("body").addClass("sidebar-hovered");
				$(".sidebar-playlists").css({
					"overflow-y": "auto",
				});
			},
			function () {
				$("body").removeClass("sidebar-hovered");
				$(".sidebar-playlists").css({
					"overflow-y": "hidden",
				});
			},
		);
		$(".sidebar-playlists").css({
			"overflow-y": "hidden",
		});
	} else {
		$("body").removeClass("toggled");
		$(".sidebar-wrapper").unbind("hover");
	}
}

function spaHref(event) {
	event.preventDefault();

	const url = $(this).attr("href");
	const state = { url: url };

	$("s.btn-toggle").trigger("click");
	$(".loader").show();
	history.pushState(state, "", url);
	loadPageContent(url);
}

function loadPageContent(url) {
	$.ajax({
		type: "GET",
		url: "/template" + url,
		dataType: "json",
		success: function (response) {
			console.log("success:", response);
			$("#main-content").html(response.data);

			console.log(url);

			const fUrlpart = url.split("/")[1];
			// init current page elements
			pageInit(fUrlpart);
			// close sidebar when it toggled on phone
			if (window.innerWidth <= 1200 && $("body").hasClass("toggled")) {
				$(".btn-toggle").trigger("click");
			}
			$(".loader").hide();
		},
		error: function (xhr, status, error) {
			alert("Error ", error);
		},
	});
}

function pageInit(url) {
	if (url == "") {
		splideInit();
		spaLinkEventInit();
		trackPlayer.playlistStartBtnInit();
		trackPlayer.reloadPlaylistPlayBtn();
	} else if (url == "profile") {
		splideInit();
	} else if (url == "uploadtrack") {
		// select2Init();
		uploadTrackPageInit();
	} else if (url == "playlist") {
		trackPlayer.playlistStartBtnInit();
		trackPlayer.trackStartBtnInit();
		trackPlayer.reloadPlaylistPlayBtn();
		trackPlayer.reloadActivetrack();
		spaLinkEventInit();
	} else if (url == "settings") {
		settingsPageInit()
	}
}

function splideInit() {
	// initialize a splides for main menu
	// fix a splide perPage bug
	const sliders = document.querySelectorAll(".splide");
	sliders.forEach((slider) => {
		new Splide(slider, {
			type: "slide",
			perPage: 2,
			gap: "1rem",
			pagination: false,
			arrows: true,
			drag: true,
		}).mount();
	});
}

function select2Init() {
	$(".select2").select2({
		placeholder: "Type to search or add...",
		theme: "bootstrap-5",
	});
}

function spaLinkEventInit() {
	$("#main-content a[data-link]").click(spaHref);
}

// show messages
function showAlert(message, func = () => {}) {
	bootbox.alert({
		message: message,
		callback: function () {
			func();
		},
	});
}

function showDialog(message, func) {
	bootbox.dialog({
		message: message,
		buttons: {
			confirm: {
				label: "Yes",
				className: "btn-success",
				callback: function () {
					func();
				},
			},
			cancel: {
				label: "No",
				className: "btn-danger",
			},
		},
	});
}
