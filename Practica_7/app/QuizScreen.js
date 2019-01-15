import React, { Component } from 'react';
import { connect } from 'react-redux';
import Game from "./Game";
import {ActivityIndicator, StyleSheet, Text, View, Image, Alert, AsyncStorage } from 'react-native';
import {Button} from 'react-native-elements';
import Icon from 'react-native-vector-icons/FontAwesome';
import {questionAnswer , changeQuestion, submit, fetchState, start, reduce_counter, finish, load_Data} from './actions'

class QuizScreen extends Component {

componentDidMount(){
  this.props.dispatch(fetchState())
  this.props.dispatch(start())
    setInterval( () => { 
      if(this.props.timer >= 1){
    this.props.dispatch(reduce_counter());}}, 1000)}

componentDidUpdate(){
  if(this.props.timer <= 0 ){
    this.props.dispatch(submit(this.props.questions))
  }}


render() {

    console.log(this.props);
    if(this.props.fetch.fetching){
      return (
        <View style={{flex:1}}>
          <View style={styles.navbar}>
             <Button name="Volver" 
              style={styles.backButton} 
              title="Volver"   
              titleStyle={{color:'black'}}
              clear
              onPress={() => this.props.navigation.goBack()} 
              icon={
                <Icon name='arrow-left' size={20}/>
              }>Volver</Button>

              <Image source={{uri : 'https://cdn3.iconfinder.com/data/icons/quiz/96/quiz_11-512.png'}} style={styles.image} />

          </View>
          
          <View style={styles.spinner}>
            <ActivityIndicator size="large" color="#0000ff" />
          </View>
          </View>
    )} 
    else if(this.props.fetch.fetching===false && this.props.error){
        console.log(this.props.fetch.error)
    }
    else{
      if(this.props.finished === false){

        return (
        <View style={{flex:1}}>
          <View style={styles.navbar}>
            
             <Button name="Volver" 
              style={styles.backButton} 
              title="Volver"   
              titleStyle={{color:'black'}}
              clear
              onPress={() => this.props.navigation.goBack()} 
              icon={
                <Icon name='arrow-left' size={20}/>
              }>Volver</Button>
              <Image source={{uri : 'https://cdn3.iconfinder.com/data/icons/quiz/96/quiz_11-512.png'}} style={styles.image} />

          </View>
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
            questions = {this.props.questions}

            storeData = {()=>{
              this._storeData(this.props.questions);
            }}
            load_Data = {()=>{
              this._retrieveData();
            }}
            remove_Data = {()=>{
              this._remove_Data();
            }}
          />
        </View>
          );
      }
      else{
        return(
        <View style={{flex:1}}>
                  <View style={styles.navbar}>
             <Button name="Volver" 
              style={styles.backButton} 
              title="Volver"   
              titleStyle={{color:'black'}}
              clear
              onPress={() => this.props.navigation.goBack()} 
              icon={
                <Icon name='arrow-left' size={20}/>
              }>Volver</Button>
              <Image source={{uri : 'https://cdn3.iconfinder.com/data/icons/quiz/96/quiz_11-512.png'}} style={styles.image} />

          </View>
        <View style={{flex:2}}>
        </View>
        <View style={{flex:3}}>

          <View style={{height:"50%", margin:10, justifyContent:'space-between', alignItems: 'center', marginTop:50}}>
            <Text>Se terminó la partida, tu puntuación es de:</Text>
            <Text style={{fontSize: 25, fontWeight: 'bold'}}>{this.props.score}</Text>
            <Button buttonStyle={styles.buttons} title="Volver" onPress={() => {this.props.dispatch(start()); this.props.dispatch(fetchState())}}>Volver</Button>
          </View>
        </View>
        <View style={{flex:2}}>
        </View>
        </View>
                  );
      }
  }
}
//AsyncStorage
_storeData = async (questions) => {
  try {
    await AsyncStorage.setItem('@P7_2018_IWEB:quiz', JSON.stringify(questions));
    this._showAlert('Las preguntas han sido guardadas.');
  } catch (error) {
    this._showAlert(error.toString());
  }
}

_retrieveData = async () => {
  try {
    const string = await AsyncStorage.getItem('@P7_2018_IWEB:quiz');
    const quiz_array = JSON.parse(string);

    if (string != null) {
      this._showAlert('Las preguntas han sido cargadas');

      this.props.dispatch(load_Data(quiz_array));
    }
    else{
      this._showAlert('No hay preguntas guardadas');
    }
   } catch (error) {
    this._showAlert(error.toString())
   }
}

_remove_Data = async () => {
  try{
    await AsyncStorage.setItem('@P7_2018_IWEB:quiz', '')
    this._showAlert('Las preguntas han sido borradas.');
  } catch (error) {
    this._showAlert(error.toString());
  }
}

  _showAlert = (text) => {
    Alert.alert(
      text,
      undefined,
      [{text: 'OK', onPress: () => console.log('OK Pressed')}],
      { cancelable: true }
)
  }
}

function mapStateToProps(state) {
  return {
    ...state
  }
  };
//

const styles = StyleSheet.create({
  backButton:{
    justifyContent: 'flex-end',
    color:'black',
    backgroundColor: 'skyblue',
    marginLeft: 5
  },
  navbar:{
    flexDirection:'row',
    height:60,
    width: "100%",
    backgroundColor: 'skyblue',
    alignItems:'center',
    justifyContent: 'space-between'
  },
  buttons: {
    marginTop:5,
    backgroundColor: 'skyblue',
    borderRadius: 15 
  },
  image:{
    height:60,
    height:"100%",
    aspectRatio:1
  },
  spinner: {
    flex:1,
    justifyContent: 'center',
    alignItems: 'center'
  }
})



export default connect(mapStateToProps)(QuizScreen);
