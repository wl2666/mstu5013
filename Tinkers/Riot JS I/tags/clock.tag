<clock>
  <div>
    <p>{ hour } : { minute } : { second }</p>
  </div>

<script>
  let tag = this;

  showTime() {
    const date = new Date();
    this.hour = date.getHours(); //should be 0-23
    this.minute = date.getMinutes(); //should be 0-59
    this.second = date.getSeconds(); //should be 0-59

    //displaying in the form of hh:mm:ss
    this.hour = (this.hour < 10) ? "0" + this.hour : this.hour;
    this.minute = (this.minute < 10) ? "0" + this.minute : this.minute;
    this.second = (this.second < 10) ? "0" + this.second : this.second;
    this.update();
  }.bind(tag);

  setInterval(this.showTime, 1000);

  this.showTime();

</script>

</clock>
