import React from 'react';
import { StyleSheet, Text, View } from 'react-native';
import { StatusBar } from 'react-native';

function WelcomeScreen(props) {
    return (
        <View style={styles.container}>
            <StatusBar hidden={true}/>
            <Text>seggsaa</Text>
        </View>
    );
}

const styles = StyleSheet.create({
    container: {
        backgroundColor: '#aaa',
        color: 'red',
        paddingTop: 14
    }
});

export default WelcomeScreen;