<metronome>
	<button disabled={ playing } class="btn btn-success" type="button" onclick={ startMetronome }>START</button>
	<button class="btn btn-danger" type="button" onclick={ stopMetronome }>STOP</button>

	<script>
		const BEAT = 1000;
		let metronome;
		let beatA = new Audio('./sounds/snareA.wav');
		let beatB = new Audio('./sounds/snareB.wav');
		let beatC = new Audio('./sounds/credulous.mp3');
		let beatD = new Audio('./sounds/filling-your-inbox.mp3');
		let beatE = new Audio('./sounds/get-outta-here.mp3');
		let beatF = new Audio('./sounds/glass-breaking.mp3');
		let beatG = new Audio('./sounds/just-like-magic.mp3');
		let beatH = new Audio('./sounds/Tamba_112.mp3');

		this.playing = false;
		this.beatIndex = 0;
		this.beatCount = 0;

		let allUsersRef = database.collection('sound-rooms').doc(opts.room.id).collection('users');
		let allUsers =[];

		//get data from database
		allUsersRef.onSnapshot(snapshot => {
		allUsers = [];
		snapshot.forEach(doc => {
			let data = doc.data();
					data.id = doc.id;
					allUsers.push(data);
		});
		this.update();
		console.log(allUsers.length);
	  });



		metroSound() {
			let k;
      //loop through data
			for (let i = 0; i < 16; i++) {
				let onArr = [];
        for (let j = 0; j < allUsers.length; j++) {
	         if (allUsers[j].notes[i].play === true) {
						onArr.push(allUsers[j].notes[i].play);
					}
        }

				k = onArr.length;
				console.log(k);

				if (k === 1) {
					beatA.play();
				} else if (k === 2) {
					beatC.play();
				} else if (k === 3) {
					beatG.play();
				} else if (k === 4) {
					beatH.play();
				} else if (k === 5) {
					beatF.play();
				} else if (k === 6) {
					beatD.play();
				}
			}


			// if (this.beatCount === 2) {
			// 	beatB.play();
			// }

			observer.trigger('onBeat', this.beatIndex);

			// if (this.beatCount < 2) {
			// 	this.beatCount++;
			// } else {
			// 	this.beatCount = 0;
			// }
			if (this.beatIndex < 15) {
				this.beatIndex++;
			} else {
				this.beatIndex = 0;
			}
		}

		startMetronome() {
			metronome = setInterval(this.metroSound, BEAT);
			this.playing = true;
		}
		stopMetronome() {
			clearInterval(metronome);
			this.beatCount = 0;
			this.beat = 0;
			this.playing = false;
		}
	</script>

	<style>
		:scope {
			display: block;
		}
	</style>
</metronome>
