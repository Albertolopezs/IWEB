import React, { Component } from 'react';
import './App.css';
import { connect } from 'react-redux';
import Game from "./Game";
import {questionAnswer , changeQuestion, submit, fetchState, start, reduce_counter, finish} from './redux/actions'

import quizImage from'./img/quiz.png';
class App extends Component {

componentDidMount(){
  this.props.dispatch(fetchState())
  this.props.dispatch(start())
    setInterval( () => { 
    this.props.dispatch(reduce_counter());}, 1000)}

componentDidUpdate(){
  if(this.props.timer <= 0 ){
    this.props.dispatch(submit(this.props.questions))
  }}
render() {

    console.log(this.props);
    if(this.props.fetch.fetching){
      return (
        <div id="loading"></div>)
    } 
    else if(this.props.fetch.fetching===false && this.props.error){
      console.log(this.props.fetch.error)
    }
    else{
    if(this.props.finished === false){


 
    
    return (
      <div>
        <div id = "topbar"><img src={quizImage}/></div>
        <div id = "App">
        

          <Game question={this.props.questions[this.props.currentQuestion]}
                onQuestionAnswer={(answer)=>{
                  this.props.dispatch(questionAnswer(this.props.currentQuestion, answer))
                  }}
                onChangeQuestion={(value)=>{
                  this.props.dispatch(changeQuestion(value))
                }}
                onSubmitQuestion={()=>{
                  this.props.dispatch(submit(this.props.questions))
                }}
                onReset={()=>{
                  this.props.dispatch(fetchState());
                  this.props.dispatch(start())
                }}
                timer = {this.props.timer}

                />
        
        </div>
      </div>);


    }
       else{
      return(
        <div>
          <div id = "topbar"><img src={quizImage}/></div>
          <div id ="final">
            <h3> Se terminó la partida, tu puntuación es de: </h3>
            <div id= "score">
              {this.props.score}
            </div><br/>
            <button value="Volver" class="button" onClick={() => {this.props.dispatch(start()); this.props.dispatch(fetchState())}}>Volver</button>
          </div>
        </div>);
    }
  }
}}

function mapStateToProps(state) {
  return {
    ...state
  };
}




export default connect(mapStateToProps)(App);
