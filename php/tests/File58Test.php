<?php
use PHPUnit\Framework\TestCase;
use Demo\File58;

class File58Test extends TestCase {
    public function testAdd() {
        $this->assertEquals(5, File58::add(2, 3));
    }
}
