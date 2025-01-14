// from id: create-track-form

let $trackForm = "";
let isOthersTrack = false;
let trackData = {};

// main
function uploadTrackPageInit() {
	$trackForm = $("#create-track-form");
	disableForm();
	enableForm(["trackFile"]);

	setUploadTrackEvents();
}

function disableForm(formIds = []) {
	if (formIds.length > 0)
		formIds.forEach(function (id) {
			$trackForm.find("#" + id).prop("disabled", true);
		});
	else $trackForm.find("input, select, textarea, button").prop("disabled", true);
}

function enableForm(formIds) {
	formIds.forEach(function (id) {
		$trackForm.find("#" + id).prop("disabled", false);
	});
}

// set enevnt
function setUploadTrackEvents() {
	// check track
	$("#trackFile").on("change", (e) => {
		$(".loader").show();
		const file = e.target.files[0];
		console.log("get file");

		const formData = new FormData();
		formData.append("track", file);

		$.ajax({
			type: "POST",
			url: "/trackcheck",
			data: formData,
			dataType: "JSON",
			processData: false,
			contentType: false,
			success: function (response) {
				$(".loader").hide();
				if (response.status == "SUCCESSFUL") {
					disableForm();
					if (response.trackStatus == "FOUND") {
						trackFounded(response.track);
					} else {
						trackNotFound();
					}
				} else {
					showAlert(response.message, () => {
						const defaultImage = $("#default-image").attr("src");
						$(".track-img-preview").each((i, elem) => {
							$(elem).attr("src", defaultImage);
						});
						$trackForm[0].reset();
					});
				}
			},
		});
	});

	$("#trackImage").on("change", function (event) {
		const file = event.target.files[0];
		if (file) {
			const reader = new FileReader();
			reader.onload = function (e) {
				$(".track-img-preview").each((i, elem) => {
					$(elem).attr("src", e.target.result);
				});
			};
			reader.readAsDataURL(file);
		} else {
			$("#imagePreview").hide();
		}
	});

	$("#trackName").on("input", checkForm);
	$("#trackImage").on("change", checkForm);

	$trackForm.on("submit", formSubmit);
}

function trackFounded(track) {
	trackData = track;
	isOthersTrack = true;
	$("#trackName").val(track.name);
	$("#artist").val(track.artist);
	$(".track-img-preview").each((i, elem) => {
		$(elem).attr("src", track.image);
	});
	enableForm(["submitBtn", "trackFile"]);
}

function trackNotFound() {
	isOthersTrack = false;
	$("#trackName").val("");
	$("#artist").val("You are creator");
	enableForm(["trackFile", "trackImage", "trackName"]);
}

function checkForm() {
	const nameExist = $("#trackName").val().trim().length > 0;
	const imageExist = $("#trackImage")[0].files.length > 0;
	if (nameExist && imageExist) {
		enableForm(["submitBtn"]);
	} else {
		disableForm(["submitBtn"]);
	}
}

function formSubmit(e) {
	e.preventDefault();
	showDialog("Do you want upload track?", () => {
		saveTrack();
	});
}

function saveTrack() {
	const formData = new FormData();
	$(".loader").show();
	if (!isOthersTrack) {
		formData.append("track", $("#trackFile")[0].files[0]);
		formData.append("name", $("#trackName").val());
		formData.append("image", $("#trackImage")[0].files[0]);
		// formData.append("artist", "");
	} else {
		formData.append("track", $("#trackFile")[0].files[0]);
		formData.append("name", trackData.name);
		formData.append("image", trackData.image);
		formData.append("artist", trackData.artist);
	}

	$.ajax({
		type: "POST",
		url: "/trackupload",
		data: formData,
		dataType: "JSON",
		processData: false,
		contentType: false,
		success: function (response) {
			$(".loader").hide();
			if (response.status == "SUCCESSFUL") {
				showAlert(response.message, () => {
					const defaultImage = $("#default-image").attr("src");
					$(".track-img-preview").each((i, elem) => {
						$(elem).attr("src", defaultImage);
					});
					$trackForm[0].reset();
				});
			} else {
				showAlert(response.message);
			}
		},
	});
}
