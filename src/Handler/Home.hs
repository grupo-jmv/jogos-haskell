{-# LANGUAGE NoImplicitPrelude #-}
{-# LANGUAGE OverloadedStrings #-}
{-# LANGUAGE TemplateHaskell #-}
{-# LANGUAGE QuasiQuotes #-}
{-# LANGUAGE MultiParamTypeClasses #-}
{-# LANGUAGE TypeFamilies #-}
module Handler.Home where

import Import
import Text.Lucius
import Text.Julius
--import Network.HTTP.Types.Status
import Database.Persist.Postgresql

getHomeR :: Handler Html
getHomeR = do 
    defaultLayout $ do 
        -- remoto
        addScriptRemote "https://code.jquery.com/jquery-3.4.1.min.js"
        -- esta no projeto
        addStylesheet (StaticR css_bootstrap_css)
        sess <- lookupSession "_NOME"
        toWidgetHead [julius|
            function ola(){
                alert("OLA MUNDO");
            }
        |]
        toWidgetHead [lucius|
            h1 {
                color : red;
            }
            
            ul {
                display: inline;
                list-style: none;
            }
        |]
        [whamlet|
            <div>
                <h1>
                    OLA MUNDO
            
            <ul>
                <li>
                    <a href=@{DesenvolvedorasR}>
                        DesenvolvedorasR
                
                <li>
                    <a href=@{DesenvolvedoraR}>
                        DesenvolvedoraR
                
                <li>
                    <a href=@{JogosR}>
                        JogosR
                
                <li>
                    <a href=@{JogoR}>
                        JogoR
                
                $maybe nome <- sess
                    <li>
                        <div>
                            Ola #{nome}
                        <form method=post action=@{SairR}>
                            <input type="submit" value="Sair">
                $nothing
                    <li>
                        <div>
                            convidado
            
            <img src=@{StaticR citeg_jpg}>
            
            <button class="btn btn-danger" onclick="ola()">
                OK
        |]
