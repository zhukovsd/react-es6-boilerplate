import React from 'react';
import News from "../News/News";

export default class App extends React.Component {
    constructor(props) {
        super(props);
        this.state = {clickCount: 0};

        this.handleClick = this.handleClick.bind(this);
    }

    handleClick() {
        this.setState(prevState => {
            ++prevState.clickCount
        });
    }

    render() {
        return (
            <div className='app' onClick={this.handleClick}>
                Hi, I'm an App component, click count = {this.state.clickCount}
                <News/>
            </div>
        );
    }
}