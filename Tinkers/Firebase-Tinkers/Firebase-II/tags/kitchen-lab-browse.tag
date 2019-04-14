<kitchen-lab-browse>
  <!-- HTML -->
  <h3>
		Explore Labs:
		<select ref="mode" onchange={ setMode }>
			<option value="all" selected>All Labs</option>
			<option value="me">My Labs</option>
			<option each={ restriction in user.restrictions } value={ restriction }>Only { restriction }</option>
		</select>
	</h3>

	<div class="laboratory" each={ lab, i in labs }>
		<h4>
      <button class="joinBtn">JOIN LAB</button> { lab.name }
      <input if={ user.username == lab.owner } ref="changeLab-{i}" value="" placeholder="Edit your lab here">
      <button if={ user.username == lab.owner } class="joinBtn" onclick={ editLab }>EDIT</button>
      <button if={ user.username == lab.owner } class="joinBtn" onclick={ deleteLab }>DELETE</button>
    </h4>
	</div>

	<p hide={ labs.length > 0 }>No Labs Found...</p>


  <script>
    // JAVASCRIPT
		this.user = opts.user;
		this.mode = "all";
		this.labs = [];


		let stopListening;
		let queryAll = database.collection('kitchen-labs').limit(10);
		let queryMine = database.collection('kitchen-users').doc(this.user.username).collection('labs').limit(10);


		setMode(event) {
			this.mode = this.refs.mode.value;
			this.changeQuery();
		}

		changeQuery() {
			stopListening();

			if (this.mode == "all") {
				stopListening = queryAll.onSnapshot(snapshot => {
          this.labs = [];

					snapshot.forEach(doc => {
            let data = doc.data();
                data.id = doc.id;
            this.labs.push(data);
          });

					this.update();
				});
			} else if (this.mode == "me") {
				stopListening = queryMine.onSnapshot(snapshot => {
          this.labs = [];

					snapshot.forEach(doc => {
            let data = doc.data();
                data.id = doc.id;
            this.labs.push(data);
          });
					this.update();
				});
			} else {
				stopListening = queryAll.where('keywords', 'array-contains', this.mode).onSnapshot(snapshot => {
          this.labs = [];

					snapshot.forEach(doc => {
            let data = doc.data();
                data.id = doc.id;
            this.labs.push(data);
          });
					this.update();
				});
			}
		}


    editLab(event) {
      let editContent = event.item.lab;
      let myLabRef = database.collection('kitchen-users').doc(this.user.username).collection('labs').doc(editContent.id);
      let userLabRef = database.collection('kitchen-labs').doc(editContent.id);
      let labTitle = this.refs['changeLab-' + event.item.i].value;
      myLabRef.update({
        name: labTitle
      });
      userLabRef.update({
        name: labTitle
      })
      this.update();
    }

    deleteLab(event) {
      let lab = event.item.lab;
      database.collection('kitchen-users').doc(this.user.username).collection('labs').doc(lab.id).delete();
      database.collection('kitchen-labs').doc(lab.id).delete();
      this.update();
    }

		this.on('mount', () => {
			stopListening = queryAll.onSnapshot(snapshot => {
        this.labs = [];

        snapshot.forEach(doc => {
          let data = doc.data();
              data.id = doc.id;
          this.labs.push(data);
        });
				this.update();
			});
		});

		this.on('unmount', stopListening);

  </script>

  <style>
    /* CSS */
    :scope {}
		.laboratory {
			border: 1px solid grey;
			padding: 0.5em;
			margin: 0;
			margin-bottom: 1em;
			border-radius: 0.25em;
		}
		.laboratory h4 {
			margin: 0;
		}
		button.joinBtn {
			cursor: pointer;
			margin-right: 1em;
			vertical-align: middle;
			transition: background-color 0.25s ease-in-out;
		}
		button.joinBtn:hover {
			background-color: green;
		}
  </style>
</kitchen-lab-browse>
