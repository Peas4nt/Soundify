function settingsPageInit() {
	setSettingsEvents();
	setEventsToForms();
}

function setSettingsEvents() {
	$('form#privacy_inputs input[type="checkbox"]').on("input", function () {
		saveUserData($(this).attr("name"), this.checked);
	});

	$("#image").on("change", function (event) {
		const file = event.target.files[0];
		if (file) {
			const reader = new FileReader();
			reader.onload = function (e) {
				$(".avatar-img-preview").each((i, elem) => {
					$(elem).attr("src", e.target.result);
				});
			};
			reader.readAsDataURL(file);
		} else {
			$("#imagePreview").hide();
		}
  });
  
  let showPass1 = true;
	let showPass2 = true;
	let showPass3 = true;

	$("input[name='new_password'")
		.parent()
		.find(".show-pass-btn")
		.on("click", (e) => {
			e.preventDefault();
			console.log("Check event");
			showPass1 = !showPass1;
			showPassEvent("input[name='new_password'", showPass1, e.currentTarget);
		});

	$("input[name='new_password_confirm'")
		.parent()
		.find(".show-pass-btn")
		.on("click", (e) => {
			e.preventDefault();
			showPass2 = !showPass2;
			showPassEvent("input[name='new_password_confirm'", showPass2, e.currentTarget);
		});

  	$("input[name='password']")
		.parent()
		.find(".show-pass-btn")
		.on("click", (e) => {
			e.preventDefault();
			showPass3 = !showPass3;
			showPassEvent("input[name='password'", showPass3, e.currentTarget);
    });
  
	function showPassEvent(passwordInputSelector, isVisible, toggleBtn) {
		const $input = $(passwordInputSelector);
		const $eyeIcon = $(toggleBtn).find("#show-pass");
		const $eyeSlashIcon = $(toggleBtn).find("#hide-pass");
		if (isVisible) {
			$input.attr("type", "text");
			$eyeIcon.show();
			$eyeSlashIcon.hide();
		} else {
			$input.attr("type", "password");
			$eyeIcon.hide();
			$eyeSlashIcon.show();
		}
	}

	$(".show-pass-btn").trigger("click")
}

function setEventsToForms() {
	$(".settings-form").on("submit", function (e) {
		e.preventDefault();
		const form = this;
		const formData = new FormData();
		const id = $(form).attr("id");

		$(form)
			.find("input")
			.each(function () {
				const type = $(this).attr("type");
				const name = $(this).attr("name");
				const value = $(this).val();

				if (type === "file") {
					formData.append("image", $(this)[0].files[0]);
				} else if (type !== "submit") {
					formData.append(name, value);
				}
			});

		$(".loader").show();
		$.ajax({
			type: "PUT",
			url: "/updatesettings/" + id,
			data: formData,
			dataType: "JSON",
			processData: false,
			contentType: false,
			success: function (response) {
				$(".loader").hide();

				clearWarnings();
				if (response.status == "SUCCESSFUL") {
					if (id == "username") {
						$(".user-name").html(response.data.username);
					} else if (id == "image") {
						$(".user-image").each(function () {
							$(this).attr("src", response.data.image_path);
						});
					}
					showAlert(response.message, () => {
						$(form)[0].reset();
					});
				} else {
					const errors = response.data;
					for (const key in errors) {
						if (Object.hasOwn(errors, key)) {
							const element = errors[key];

							$(form).find(`input[name="${key}"]`).parent().parent().find(".text-danger").html(element);
						}
					}
				}
			},
			error: function (jqXHR, textStatus, errorThrown) {
				console.log(errorThrown);
			},
		});
	});
}

function clearWarnings() {
	$(".settings-form").each(function () {
		$(this)
			.find(".text-danger")
			.each(function () {
				$(this).html("");
			});
	});
}
