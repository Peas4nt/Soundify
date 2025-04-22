class TrackPlayer {
	constructor(recentTrackKey = null, recentPlaylistSlug = null, userData = {}) {
		// buttons
		this.nextButton = $("#btn-next");
		this.previousButton = $("#btn-prev");
		this.playButton = $("#btn-play");
		this.playIcon = $("#play");
		this.pauseIcon = $("#pause");

		this.timeSlider = $("#track-range");
		this.currentTimeLabel = $("#track-time");
		this.totalTimeLabel = $("#track-max-time");

		this.repeatButton = $("#music-loop");
		this.shuffleButton = $("#music-random");

		this.volumeButton = $("#mute-volume");
		this.volumeSlider = $("#music-volume");

		this.trackInfo = $(".track-info");
		this.trackImage = $(".track-info #track-img");
		this.trackName = $(".track-info #track-name");
		this.trackArtist = $(".track-info #track-author");
		this.trackPlaylsit = $(".track-info #playlist-href");
		this.trackAudio = $(".track-info #track");

		// tracks data
		this.trackArr = [];
		// this.trackQuery = [];
		this.playedTracks = [];

		this.isTrackPlaying = false;

		this.isShuffle = userData?.shuffle_value || false;
		this.isRepeat = userData?.repeat_value || false;

		this.nextTrackIndex = null;
		this.playingTrackKey = null;
		this.playingPlaylistSlug = null;
		this.playingPlaylstKey = null;

		this.volume = parseFloat(userData?.volume_value) || 0.2;

		console.log(userData);

		this.initControls();
		// recent track loading
		if (recentTrackKey && recentPlaylistSlug) this.playPlaylist(recentPlaylistSlug, recentTrackKey, false);
	}
	initControls() {
		const that = this;
		let saveTimeout;

		// Play/Pause functionality
		this.playButton.on("click", function () {
			if (that.isTrackPlaying) {
				that.pauseTrack();
			} else {
				that.playTrack();
			}
		});

		// Show play icon
		this.trackAudio.on("play", function () {
			that.playIcon.hide();
			that.pauseIcon.show();

			// show play icon on playlist button
			$(`.play-playlist#${that.playingPlaylistSlug}`).each(function (i, e) {
				$(e).find("#play").hide();
				$(e).find("#pause").show();
			});
		});

		// Show pause icon
		this.trackAudio.on("pause", function () {
			that.playIcon.show();
			that.pauseIcon.hide();

			// show pause icon on playlist button
			$(`.play-playlist#${that.playingPlaylistSlug}`).each(function (i, e) {
				$(e).find("#play").show();
				$(e).find("#pause").hide();
			});
		});

		this.trackAudio.onloadeddata = () => {
			this.updateTime();
		};

		// Next track
		this.nextButton.on("click", function () {
			that.nextTrack();
			that.playTrack();
		});

		// Previous track
		this.previousButton.on("click", function () {
			that.previousTrack();
			that.playTrack();
		});

		// Update time slider during playback
		this.trackAudio.on("timeupdate", function () {
			that.updateTime();
		});

		// Set track position from time slider
		this.timeSlider.on("input", function () {
			that.trackAudio[0].currentTime = $(this).val();
			that.volume = $(this).val();
		});

		// Eliminates the problem of jerky sound when rewinding
		this.timeSlider.on("mousedown", function () {
			that.trackAudio[0].pause();
		});

		this.timeSlider.on("mouseup", function () {
			that.trackAudio[0].play();
		});

		// Mute/Unmute
		this.volumeButton.on("change", function () {
			that.setVolumeMute($(this).is(":checked"));
		});

		// Volume slider
		this.volumeSlider.on("input", function () {
			that.setVolume($(this).val());

			if (that.trackAudio[0].muted) {
				that.trackAudio[0].muted = false;
				that.updateVolumeIcon(false);
			}

			// save volume data
			clearTimeout(saveTimeout);
			saveTimeout = setTimeout(() => {
				saveUserData("volume_value", $(this).val(), false);
			}, 5000);
		});

		this.repeatButton.on("change", function () {
			that.isRepeat = $(this).is(":checked");
			that.updateRepeatIcon();
			saveUserData("repeat_value", that.isRepeat);
		});

		this.shuffleButton.on("change", function () {
			that.isShuffle = $(this).is(":checked");
			that.updateShuffleIcon();
			saveUserData("shuffle_value", that.isShuffle);
		});

		this.trackAudio.on("canplaythrough", function () {
			if (that.isTrackPlaying) {
				that.trackAudio[0].play();
			}
		});

		this.trackAudio.on("error", function () {
			that.nextTrack(true);
			console.log("Track load error");
		});

		this.setVolume(this.volume);
		this.updateRepeatIcon();
		this.updateShuffleIcon();
	}

	playTrack() {
		this.trackAudio[0].play();
		this.isTrackPlaying = true;
	}

	pauseTrack() {
		this.trackAudio[0].pause();
		this.isTrackPlaying = false;
	}

	nextTrack(auto = false) {
		this.nextTrackIndex++;
		if (this.nextTrackIndex == this.trackArr.length) {
			this.nextTrackIndex = 0;
		}

		this.playedTracks.push(this.playingTrackKey);

		if (this.trackArr.length == this.playedTracks.length) {
			this.playedTracks = [];
		}

		if (this.isShuffle) {
			let trackArrIndex;
			let trackKey;
			do {
				trackArrIndex = Math.floor(Math.random() * this.trackArr.length);
				trackKey = this.trackArr[trackArrIndex];

				console.log("Track key: ", trackKey);
			} while (this.playedTracks.includes(trackKey));
			this.nextTrackIndex = trackArrIndex;
		}

		this.getTrack();

		if (!this.isRepeat && auto && this.nextTrackIndex == 0) this.pauseTrack();
		else this.playTrack();
	}

	previousTrack() {
		this.nextTrackIndex--;
		if (this.nextTrackIndex < 0) this.nextTrackIndex = this.trackArr.length - 1;

		if (this.isShuffle) {
			if (this.playedTracks.includes(this.playingTrackKey)) {
				const index = this.playedTracks.indexOf(this.playingTrackKey);
				this.playedTracks.splice(index, 1);
			}
			if (this.playedTracks.length != 0) this.nextTrackIndex = this.playedTracks.length - 1;
		}

		this.getTrack();
	}

	updateTime() {
		const currentTime = this.trackAudio[0].currentTime;
		const duration = this.trackAudio[0].duration;

		this.currentTimeLabel.text(this.formatTime(currentTime));
		this.totalTimeLabel.text(this.formatTime(duration));
		this.timeSlider.attr("max", duration).val(currentTime);

		if (currentTime == duration) this.nextTrack(true);
	}

	formatTime(seconds) {
		const minutes = Math.floor(seconds / 60);
		const secs = Math.floor(seconds % 60);
		return `${minutes}:${secs < 10 ? "0" + secs : secs}`;
	}

	setVolume(value) {
		this.trackAudio[0].volume = value;
		this.volume = value;
		this.volumeSlider.val(value);
	}

	setVolumeMute(isMuted) {
		this.trackAudio[0].muted = isMuted;
		this.updateVolumeIcon(isMuted);
		if (isMuted) $(this.volumeSlider).val(0);
		else $(this.volumeSlider).val(this.volume);
	}

	updateVolumeIcon(isMuted) {
		if (isMuted) {
			$("#mute-volume-label").find(".checked").show();
			$("#mute-volume-label").find(".unchecked").hide();
		} else {
			$("#mute-volume-label").find(".checked").hide();
			$("#mute-volume-label").find(".unchecked").show();
		}
	}

	updateRepeatIcon() {
		if (this.isRepeat) {
			$("#music-loop-label").find(".checked").show();
			$("#music-loop-label").find(".unchecked").hide();
			$(this.repeatButton).prop("checked", true);
		} else {
			$("#music-loop-label").find(".checked").hide();
			$("#music-loop-label").find(".unchecked").show();
			$(this.repeatButton).prop("checked", false);
		}
	}

	updateShuffleIcon() {
		if (this.isShuffle) {
			$("#music-random-label").find(".checked").show();
			$("#music-random-label").find(".unchecked").hide();
			$(this.shuffleButton).prop("checked", true);
		} else {
			$("#music-random-label").find(".checked").hide();
			$("#music-random-label").find(".unchecked").show();
			$(this.shuffleButton).prop("checked", false);
		}
	}

	playlistStartBtnInit() {
		const that = this;
		$(".play-playlist").on("click", function (e) {
			e.stopPropagation();
			e.preventDefault();
			const button = $(e.target).closest(".play-playlist");
			const id = $(button).attr("id");
			$(button).addClass(".active");

			that.playPlaylist(id);
		});

		that.reloadPlaylistPlayBtn();
		that.reloadAtivePlaylist();
	}

	trackStartBtnInit() {
		const that = this;
		$(".track").on("click", function (e) {
			const track = $(e.target).closest(".track");
			const trackKey = $(track).attr("id");
			const playlistKey = $(track).attr("playlist");

			console.log(trackKey, " ", playlistKey);
			that.playPlaylist(playlistKey, trackKey);
		});
	}

	async playPlaylist(playlistKey, trackKey = null, playTrack = true) {
		console.log(this.playingPlaylistSlug, "   ", playlistKey);

		if (this.playingPlaylistSlug == playlistKey) {
			if (trackKey == null || trackKey == this.nextTrackIndex) {
				if (this.isTrackPlaying) this.pauseTrack();
				else this.playTrack();

				console.log("Pause or play playlist");

				return null;
			} else {
				// start choossed track
				console.log("change track in selected playlist");
				const index = this.trackArr.indexOf(parseInt(trackKey));
				if (index == -1) return null;
				this.nextTrackIndex = index;

				this.getTrack();
				this.playTrack();
				return null;
			}
		}

		console.log("Play playlist: " + playlistKey);
		const data = await $.ajax({
			type: "POST",
			url: `/playlist/get/${playlistKey}`,
		});

		if (data.status == "OK") {
			if (!data.data.tracks || data.data.tracks.length == 0) {
				showAlert("This playlist has no tracks");
				return null;
			}
			this.trackArr = data.data.tracks;
			this.playingPlaylistSlug = data.data.slug;
			this.playingPlaylstKey = data.data.playlist_key;
			this.playedTracks = [];

			if (trackKey) this.nextTrackIndex = this.trackArr.indexOf(parseInt(trackKey));
			else this.nextTrackIndex = 0;

			this.trackPlaylsit.text(data.data.name || "No Playlist");

			this.getTrack();

			// reload active playlist btns
			this.reloadAtivePlaylist();

			if (playTrack) {
				this.playTrack();
			}
		} else {
			console.error("Failed to play playlist");
		}
	}

	async getTrack() {
		let trackArrIndex = this.nextTrackIndex;
		let trackKey = (this.playingTrackKey = this.trackArr[trackArrIndex]);

		console.log(this.playedTracks);
		const data = await this.getTrackData(trackKey);

		console.log(data);
		if (data.status == "OK") {
			this.setTrackData(data.data);
		} else {
			console.error("Failed to play track");
		}
	}

	async getTrackData(key) {
		const formData = new FormData();
		formData.append("playlist_key", this.playingPlaylstKey);
		formData.append("playlist_slug", this.playingPlaylistSlug);
		return await $.ajax({
			type: "POST",
			url: `/track/get/${key}`,
			data: formData,
			dataType: "JSON",
			processData: false,
			contentType: false,
		});
	}

	setTrackData(data) {
		this.trackImage.attr("src", data.image_path || "default-image.jpg");
		this.trackName.text(data.name || "Unknown Track");
		this.trackArtist.text(data.artist_name || "Unknown Artist");
		this.trackAudio.attr("src", data.track_path || "");

		this.trackPlaylsit.attr("href", "/playlist/" + this.playingPlaylistSlug);
		this.trackInfo.attr("id", data.track_key);
		this.trackInfo.attr("playlist", this.playingPlaylistSlug);

		this.reloadActivetrack();
	}

	reloadPlaylistPlayBtn() {
		const that = this;
		$(`.play-playlist#${that.playingPlaylistSlug}`).each(function (i, e) {
			if (that.isTrackPlaying) {
				$(e).find("#play").hide();
				$(e).find("#pause").show();
			}
		});
	}

	reloadActivetrack() {
		// remove alctive class
		$(".track.active").each(function (i, e) {
			$(e).removeClass("active");
		});

		// set new active class to new track
		$(`.track#${this.playingTrackKey}[playlist='${this.playingPlaylistSlug}']`).addClass("active");
	}

	reloadAtivePlaylist() {
		const that = this;
		// remove alctive class
		$(".play-playlist.active").each(function (i, e) {
			$(e).removeClass("active");
		});

		// set new active class to new track
		console.log("active playlist: ", that.playingPlaylistSlug);

		$(`.play-playlist#${that.playingPlaylistSlug}`).addClass("active");
	}
}
