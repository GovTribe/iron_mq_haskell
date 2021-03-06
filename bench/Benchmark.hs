{-# LANGUAGE OverloadedStrings #-}

import Criterion.Main

import Network.IronMQ
import qualified Network.Wreq.Session as S
import Network.IronMQ.Types

main :: IO ()
main = defaultMain [bench "get queue info, post a message, get messages, delete message" $ nfIO (doStuff)]

testClient :: Client
testClient = Client {
    token = "DG0HDEUlDvj-oyTdM9Ua9rTxw7w",
    projectID = "54a241faaeffe60005000047",
    server = "mq-aws-us-east-1.iron.io",
    apiVersion = "1"
}


doStuff :: IO ()
doStuff = S.withSession $ \sess-> do
    _ <- queues testClient sess
    postMessages testClient sess "default" [message{mBody = "This is message number "}]
    messageList <- getMessages testClient sess "default"
    let messageID = mId (head (mlMessages messageList))
    case messageID of
        Just x -> deleteMessage testClient sess "default" x
    return ()