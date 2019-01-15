import React from 'react';
import { View, StyleSheet} from 'react-native';
import { Button } from 'react-native-elements';
export default class IndexScreen extends React.Component {
render() {
return (
	<View style={{ flex:1, alignItems:'center', justifyContent:'center' }}>
		<Button
			buttonSyle={styles.button}
			onPress={() => this.props.navigation.navigate('QuizScreen')}
			title="Jugar"/>
	</View>
)
}}
const styles = StyleSheet.create({

   buttons: {
   	marginTop:5,
    backgroundColor: 'skyblue',
    borderRadius: 15 
  }
})