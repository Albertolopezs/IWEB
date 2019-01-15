import { Provider } from 'react-redux';
import GlobalState from './reducers';
import { createStore , compose, applyMiddleware} from 'redux';
import thunk from 'redux-thunk';
import { questions } from "../assets/mock-data.js";


import React from 'react';
import App from '../App';

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
				<div style={{ height: '100%' }} >
					<App store={ this.store } />
				</div>
			</Provider>
			);
	}

	configureStore(){
		return createStore(GlobalState,this.initialState,compose(applyMiddleware( thunk))
			);
	}
}