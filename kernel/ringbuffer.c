/*
 * __kfifo_put - puts some data into the FIFO, no locking version
 * Note that with only one concurrent reader and one concurrent 
 * writer, you don't need extra locking to use these functions
 * ===========================================================
 */
unsigned int __kfifo_put (struct kfifo *fifo,
        unsigned char *buffer, unsigned int len)
{
    unsigned int l;
    len = min(len, fifo->size - fifo->in + fifo->out);
    /* first put the data starting from fifo->in to buffer end */
    l = min (len, fifo->size - (fifo->in & (fifo->size - 1)));
    memcpy (fifo->buffer + (fifo->in & (fifo->size - 1)), buffer, l);
    /* then put the rest (if any) at the beginning of the buffer */
    memcpy (fifo->buffer, buffer + l, len - l);
    fifo->in += len;
    return len;
}

