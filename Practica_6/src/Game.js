import React from 'react';
export default class Game extends React.Component {
	render(){
		return(
			<div id = "game">
			<div id="imagen">
			<img src={this.props.question.attachment.url} alt="Imagen" width ="200" height="200"></img>
			</div>

			
			<div id="preg">
				<div id="enun">
					<h3>{this.props.question.question}</h3>
					<br/>
					<br/>
					<input type="text" value={this.props.question.userAnswer || ''} onChange={(e)=>{
						this.props.onQuestionAnswer(e.target.value);}}/>
						<br/><br/>
					<div id="timer"><b>Tiempo restante:</b> {this.props.timer} </div>
				</div>
				<div id = "tips">
					<br/>
					Pistas
					<ul>
					{this.props.question.tips.map((tip, i) => <li key = {i}>{tip}</li>)}
					</ul>
				</div>
			</div>
			<div class='buttons'>
				<button value="Siguiente" class="button" onClick={()=>{this.props.onChangeQuestion(1)}}>Siguiente</button>
				<button value="Anterior"  class="button" onClick={()=>{this.props.onChangeQuestion(0)}}>Anterior</button>
				<button value="Comprobar"  class="button" onClick={()=>{this.props.onSubmitQuestion()}}>Comprobar</button>
				<button value="Reset"  class="button" onClick={()=>{this.props.onReset()}}>Reset</button>
			</div>
			</div>
			);
	}
}