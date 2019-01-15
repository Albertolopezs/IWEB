import React from 'react';
import { StyleSheet, Text, View, Image, TextInput, FlatList, AsyncStorage, Alert} from 'react-native';
import { Button } from 'react-native-elements';

export default class Game extends React.Component {
	render(){
		let url = this.props.question.attachment.url.toString()
		return(
		<View style={{flex:1}}>
		<View style={{flex:5, margin:10, justifyContent:'center'}}>
			<Image style={{flex:1, marginTop:5, justifyContent:'center', alignItems:'center'}} source={{uri : url}} />
		</View>
		<View style={{alignItems: 'center',flex:3, margin:10,justifyContent: 'space-between',}}>
			<Text style={styles.title}>{this.props.question.question}</Text>
					
			<TextInput  style={styles.textinput} textAlign={'center'} underlineColorAndroid = "transparent" placeholder = "Introduce la respuesta" placeholderTextColor = "#9a73ef" autoCapitalize = "none" value={this.props.question.userAnswer || ''}onChangeText={(e)=>{this.props.onQuestionAnswer(e);}}/>
 
			<Text>Tiempo restante: {this.props.timer}</Text>

		</View>
    <View style={{marginBottom: 5, marginLeft:10, marginRight:10}}>
    	<View style={styles.buttons_row}>
			<View style={styles.buttons_column}>
			    <Button buttonStyle={styles.buttons} onPress={() => {this.props.onChangeQuestion(0)}} title={"Anterior"}/>
			    <Button buttonStyle={styles.buttons} onPress={() => {this.props.storeData()}} title="Guardar"/>
          <Button buttonStyle={styles.buttons} onPress={() => {this.props.remove_Data()}} title="Borrar"/>
			    
			</View>
			<View style={styles.buttons_column}>
			    <Button buttonStyle={styles.buttons} onPress={() => {this.props.onChangeQuestion(1)}} title={"Siguiente"}/>
			    <Button buttonStyle={styles.buttons} onPress={() => {this.props.onReset()}} title={"Reset"}/>
			    <Button buttonStyle={styles.buttons} onPress={() => {this.props.load_Data()}} title="Cargar"/>
          
			</View>
      
		</View>
    <Button buttonStyle={styles.buttons} onPress={() => {this.props.onSubmitQuestion()}} title={"Comprobar"}/>
		</View>
    </View>
		);
	}}



const styles = StyleSheet.create({
	textinput:{
		height:40,
		width: "95%",
		marginBottom: 15,
		

	},
	title:{
		justifyContent: 'center',
		alignItems: 'center',
		fontSize: 25,
		fontWeight: 'bold',
		color: '#b30059'
	},
  buttons_row: {
  	marginTop:5,
  	marginLeft:10,
  	marginRight:10,
  	flexDirection:'row',
  	marginBottom: 10,
  	alignItems: 'center',
  	justifyContent: 'space-evenly'
  },
   buttons: {
   	marginTop:5,
    backgroundColor: 'skyblue',
    borderRadius: 15 
  },
    buttons_column: {
    flex: 3,
    marginLeft:10,
  	marginRight:10,
  	marginTop:15,
  	flexDirection:'column',
  	justifyContent:'space-evenly',
  	alignItems: 'stretch'
  },
  text: {
    alignItems: 'center',
    justifyContent: 'center',
    borderWidth: 1
  }
})