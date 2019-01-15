import {createStackNavigator, createAppContainer} from 'react-navigation';
import { Provider } from 'react-redux';
import { View } from 'react-native';
import GlobalState from './reducers';
import { createStore , compose, applyMiddleware} from 'redux';
import { questions } from "../assets/mock-data.js";
import thunk from 'redux-thunk';
import QuizScreen from './QuizScreen';
import IndexScreen from './IndexScreen';
import React from 'react';

const AppNavigator = createStackNavigator({
	IndexScreen: {screen: IndexScreen},
	QuizScreen: {screen: QuizScreen}
},{
	initialRouteName: "IndexScreen",
	headerMode: 'none'
});

const AppContainer = createAppContainer(AppNavigator);

export default class ReduxProvider extends React.Component {
	constructor(props) {
		super(props);
		this.initialState = {
			score: 0,
			finished: false,
			currentQuestion: 0,
			questions: [ ...questions ]
		};
		this.store = this.configureStore();
	}
	render() {

		return (
			<Provider store={ this.store }>
				<AppContainer/>
			</Provider>
			);
	}

	configureStore(){
		return (createStore(GlobalState,this.initialState, compose(applyMiddleware(thunk)))
			);
	}
}