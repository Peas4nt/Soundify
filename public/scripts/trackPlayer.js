class TrackPlayer {
	constructor() {
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

		this.trackImage = $(".track-info #track-img");
		this.trackName = $(".track-info #track-name");
		this.trackArtist = $(".track-info #track-author");
		this.trackPlaylsit = $(".track-info #track-playlist");
		this.trackAudio = $(".track-info #track");

		// tracks data
		this.trackArr = [];
		// this.trackQuery = [];
		this.playedTracks = [];

		this.isTrackPlaying = false;

		this.isShuffle = false;
		this.isRepeat = false;

		this.nextTrackIndex = null;
		this.playingTrackKey = null;
		this.playingPlaylistSlug = null;
		this.playingPlaylstKey = null;

		this.volume = 0.2;

		this.initControls();
	}
	initControls() {
		const that = this;

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

		// Next track
		this.nextButton.on("click", function () {
			that.nextTrack();
			setTimeout(() => that.playTrack(), 200);
		});

		// Previous track
		this.previousButton.on("click", function () {
			that.previousTrack();
			setTimeout(() => that.playTrack(), 200);
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
		});

		this.trackAudio.onloadeddata = () => {
			this.updateTime();
		};

		this.trackAudio.on("canplaythrough", function () {
			if (that.isTrackPlaying) {
				that.trackAudio[0].play();
			}
		});

		this.setVolume(this.volume);
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
		if (this.nextTrackIndex == this.trackArr.length) this.nextTrackIndex = 0;
		this.getTrack();

		if (!this.isRepeat && auto && this.nextTrackIndex == 0) this.pauseTrack();
		else setTimeout(() => this.playTrack(), 200);
	}

	previousTrack() {
		this.nextTrackIndex--;
		if (this.nextTrackIndex < 0) this.nextTrackIndex = this.trackArr.length - 1;
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

	playlistStartBtnInit() {
		const that = this;
		$(".play-playlist").on("click", function (e) {
			const button = $(e.target).closest(".play-playlist");
			const id = $(button).attr("id");

			that.playPlaylist(id);
		});
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

	async playPlaylist(playlistKey, trackKey = null) {
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
			this.trackArr = data.data.tracks;
			this.playingPlaylistSlug = data.data.slug;
			this.playingPlaylstKey = data.data.playlist_key;

			if (trackKey) this.nextTrackIndex = this.trackArr.indexOf(parseInt(trackKey));
			else this.nextTrackIndex = 0;

			this.trackPlaylsit.text(data.data.name || "No Playlist");
			this.getTrack();
			this.playTrack();
		} else {
			console.error("Failed to play playlist");
		}
	}

	async getTrack() {
		let trackArrIndex = this.nextTrackIndex;
		const trackKey = (this.playingTrackKey = this.trackArr[trackArrIndex]);

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

		this.reloadActivetrack();
	}

	reloadPlaylistPlayBtn() {
		const that = this;
		$(`.play-playlist#${that.playingPlaylistSlug}`).each(function (i, e) {
			$(e).find("#play").hide();
			$(e).find("#pause").show();
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
}
